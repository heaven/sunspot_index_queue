module Sunspot
  class IndexQueue
    # Batch of entries to be indexed with Solr.
    class Batch
      attr_reader :queue, :entries, :delete_entries

      # Errors that cause batch processing to stop and are immediately passed on to the caller. All other
      # are logged on the entry on the assumption that they can be fixed later while other entries can still
      # be processed.
      PASS_THROUGH_EXCEPTIONS = [SystemExit, NoMemoryError, Interrupt, SignalException, Errno::ECONNREFUSED]

      def initialize(queue, entries = nil)
        @queue = queue
        @entries = []
        @entries.concat(entries) if entries
        @delete_entries = []
      end

      # Submit the entries to solr. If they are successfully committed, the entries will be deleted.
      # Otherwise, any entries that generated errors will be updated with the error messages and
      # set to be processed again in the future.
      def submit!
        Entry.load_all_records(self.entries)
        submit
      rescue Exception => e
        begin
          clear_processed
          self.entries.each(&:reset!) if PASS_THROUGH_EXCEPTIONS.include?(e.class)
        ensure
          # Use a more specific error to indicate Solr is down.
          raise e.is_a?(Errno::ECONNREFUSED) ? SolrNotResponding.new(e.message) : e
        end
      ensure
        # Avoid memory leaks when processing queue in multiple threads
        @queue = nil
        self.entries.clear
        self.delete_entries.clear
      end

      private

      # First try submitting the entries in a batch since that's the most efficient.
      # If there are errors, try each entry individually in case there's a bad document.
      def submit(in_batch = true)
        clear_processed

        if in_batch
          session.batch { self.entries.each { |entry| submit_entry(entry) } }
        else
          self.entries.each { |entry| submit_entry(entry) }
        end

        commit!
      rescue Exception => e
        raise(e) if PASS_THROUGH_EXCEPTIONS.include?(e.class)

        if in_batch
          submit(false)
        else
          self.entries.each do |entry|
            entry.set_error!(e, self.queue.retry_interval) unless entry.processed?
          end
        end
      end

      # Send the Solr commit command and delete the entries if it succeeds.
      def commit!
        queue.autocommit && session.commit
        self.delete_entries.any? && Entry.delete_entries(self.delete_entries)
      rescue Exception => e
        clear_processed
        raise e
      ensure
        self.delete_entries.clear
      end

      # Send an entry to Solr doing an update or delete as necessary.
      def submit_entry(entry)
        log_entry_error(entry) do
          if entry.is_delete?
            session.remove_by_id("#{entry.id_prefix}#{entry.record_class_name}", entry.record_id)
          elsif entry.record
            session.index(entry.record)
          else
            raise RecordNotFound, "Associated record not found"
          end
        end
      end

      # Update an entry with an error message if a block fails.
      def log_entry_error(entry)
        yield

        entry.processed = true

        unless self.delete_entries.include?(entry)
          self.delete_entries << entry
        end
      rescue Exception => e
        raise(e) if PASS_THROUGH_EXCEPTIONS.include?(e.class)

        entry.set_error!(e, self.queue.retry_interval)
      end

      # Clear the processed flag on all entries.
      def clear_processed
        self.delete_entries.clear
        self.entries.each { |entry| entry.processed = false }
      end

      def session
        self.queue.session
      end
    end
  end
end
