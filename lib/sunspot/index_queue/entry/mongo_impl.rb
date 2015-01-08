require 'moped'

module Sunspot
  class IndexQueue
    module Entry
      # Implementation of an indexing queue backed by MongoDB (http://mongodb.org/). This implementation
      # uses the moped gem directly and so is independent of any ORM you may be using.
      #
      # To set it up, you need to set the connection and database that it will use.
      #
      #   Sunspot::IndexQueue::Entry::MongoImpl.connection = 'localhost'
      #   Sunspot::IndexQueue::Entry::MongoImpl.database_name = 'my_database'
      #   # or
      #   Sunspot::IndexQueue::Entry::MongoImpl.connection = Moped::Session.new(['localhost:27017'])
      #   Sunspot::IndexQueue::Entry::MongoImpl.database_name = 'my_database'
      class MongoImpl
        include Entry

        class << self
          # Set the connection to MongoDB. The args can either be a Mongo::MongoClient object, or the args
          # that can be used to create a new Mongo::MongoClient.
          def connection=(session, options = {})
            @connection = session.is_a?(Moped::Session) ? session : Moped::Session.new(session, options)
            @database_name = @connection.options[:database]
          end

          # Get the connection currently in use.
          def connection
            @connection
          end

          # Set the name of the database which will contain the queue collection.
          def database_name=(name)
            @collection = nil
            @database_name = name
          end

          # Get the collection used to store the queue.
          def collection
            unless @collection
              @collection = @connection.use(@database_name)["sunspot_index_queue_entries"]

              @collection.indexes.create(:record_class_name => 1, :record_id => 1)
              @collection.indexes.create(:priority => -1, :record_class_name => 1, :run_at => 1, :lock => 1)
            end

            @collection
          end

          # Create a new entry.
          def create(attributes)
            entry = new(attributes)
            entry.save
            entry
          end

          # Find one entry given a selector or object id.
          def find_one(spec)
            doc = collection.find(spec.is_a?(Hash) ? spec : {}.merge('_id' => spec)).first
            new(doc) if doc
          end

          def find_or_create(spec, sort, update)
            doc = collection.find(spec).sort(sort).modify(update, { :upsert => true, :new => true })
            new(doc) if doc
          end

          # Default conditions with included/excluded classes
          def conditions(queue)
            conditions = Hash.new

            if queue.class_names.any? or queue.exclude_classes.any?
              conditions[:record_class_name] = Hash.new
              conditions[:record_class_name]['$in'] = queue.class_names if queue.class_names.any?
              conditions[:record_class_name]['$nin'] = queue.exclude_classes if queue.exclude_classes.any?
            end

            conditions
          end

          # Logger used to log errors.
          def logger
            @logger
          end

          # Set the logger used to log errors.
          def logger=(logger)
            @logger = logger
          end

          # Implementation of the total_count method.
          def total_count(queue)
            collection.find(conditions(queue)).count
          end

          # Implementation of the ready_count method.
          def ready_count(queue)
            collection.find(conditions(queue).merge({ :run_at => { '$lte' => Time.now.utc }, :lock => nil })).count
          end

          # Implementation of the error_count method.
          def error_count(queue)
            collection.find(conditions(queue).merge({ :error => { '$ne' => nil } })).count
          end

          # Implementation of the errors method.
          def errors(queue, limit = 0, skip = 0)
            conditions = conditions(queue).merge({ :error => { '$ne' => nil } })
            collection.find(conditions).limit(limit).skip(skip).sort(:id => 1).map { |doc| new(doc) }
          end

          # Implementation of the reset! method.
          def reset!(queue)
            collection.find(conditions(queue)).update_all('$set' => {
              :run_at => Time.now.utc, :attempts => 0, :error => nil, :lock => nil
            })
          end

          # Implementation of the next_batch! method.
          def next_batch!(queue)
            now = Time.now.utc
            lock = rand(0x7FFFFFFF)
            run_at = now + queue.retry_interval
            conditions = {
              :priority => { '$gte' => -100 },
              :run_at => { '$lte' => now },
              :lock => nil }.merge(conditions(queue))

            # docs = []
            #
            # loop do
            #   docs << collection.find(conditions).sort(:priority => -1, :run_at => 1).
            #     modify({ '$set' => { :error => nil, :lock => lock, :run_at => run_at } }, { :new => true })
            #
            #   break if docs.size == queue.batch_size or not docs.last
            # end
            #
            # docs.compact.map { |doc| new(doc) }

            # Perform just 2 queries instead of queue.batch_size,
            #  can't work with multiple batch processors
            docs = collection.find(conditions).
              sort(:priority => -1, :record_class_name => 1, :run_at => 1).limit(queue.batch_size).to_a

            collection.find('_id' => { '$in' => docs.map { |d| d['_id'] }}).
              update_all('$set' => { :error => nil, :lock => lock, :run_at => run_at })

            docs.map { |d| new(d.merge('run_at' => run_at, 'lock' => lock, 'error' => nil)) }
          end

          # Implementation of the add method.
          def add(klass, id, delete, priority)
            find_or_create(
              { :record_class_name => klass.name, :record_id => id, :lock => nil },
              { :record_class_name => 1, :record_id => 1 },
              { '$set' => { :is_delete => delete, :run_at => 5.seconds.from_now }, '$max' => { :priority => priority } }
            )
          end

          # Implementation of the delete_entries method.
          def delete_entries(entries)
            collection.find(:_id => { '$in' => entries.map(&:id) }).remove_all
          end
        end

        attr_reader :doc

        # Create a new entry from a document hash.
        def initialize(attributes = {})
          @doc = {}

          attributes.each do |key, value|
            @doc[key.to_s] = value
          end

          @doc['priority'] = 0 unless doc['priority']
          @doc['attempts'] = 0 unless doc['attempts']
        end

        # Get the entry id.
        def id
          doc['_id']
        end

        # Get the entry id.
        def record_class_name
          doc['record_class_name']
        end

        # Set the entry record_class_name.
        def record_class_name=(value)
          doc['record_class_name'] = value.nil? ? nil : value.to_s
        end

        # Get the entry id.
        def record_id
          doc['record_id']
        end

        # Set the entry record_id.
        def record_id=(value)
          doc['record_id'] = value
        end

        # Get the entry run_at time.
        def run_at
          doc['run_at']
        end

        # Set the entry run_at time.
        def run_at=(value)
          value = Time.parse(value.to_s) unless value.nil? || value.is_a?(Time)
          doc['run_at'] = value.nil? ? nil : value.utc
        end

        # Get the entry priority.
        def priority
          doc['priority']
        end

        # Set the entry priority.
        def priority=(value)
          doc['priority'] = value.to_i
        end

        # Get the entry attempts.
        def attempts
          doc['attempts'] || 0
        end

        # Set the entry attempts.
        def attempts=(value)
          doc['attempts'] = value.to_i
        end

        # Get the entry error.
        def error
          doc['error']
        end

        # Set the entry error.
        def error=(value)
          doc['error'] = value.nil? ? nil : value.to_s
        end

        # Get the entry lock value
        def lock
          doc['lock']
        end

        # Set the entry lock value
        def lock=(value)
          doc['lock'] = value
        end

        # Get the entry delete entry flag.
        def is_delete?
          doc['is_delete']
        end

        # Set the entry delete entry flag.
        def is_delete=(value)
          doc['is_delete'] = !!value
        end

        # Save the entry to the database.
        def save
          doc['_id'] ||= BSON::ObjectId.new

          self.class.collection.find('_id' => doc['_id']).upsert(doc)

          doc
        end

        # Implementation of the set_error! method.
        def set_error!(error, retry_interval = nil)
          self.attempts += 1
          self.lock = nil
          self.error = "#{error.class.name}: #{error.message}\n#{error.backtrace.join("\n")[0, 4000]}"
          self.run_at = (retry_interval * attempts).seconds.since.utc if retry_interval
          self.save
        rescue => e
          if self.class.logger
            self.class.logger.warn(error)
            self.class.logger.warn(e)
          end
        end

        # Implementation of the reset! method.
        def reset!
          self.attempts = 0
          self.lock = nil
          self.error = nil
          self.run_at = Time.now.utc
          self.save
        rescue => e
          self.class.logger.warn(e) if self.class.logger
        end

        def == (value)
          value.is_a?(self.class) && ((id && id == value.id) || doc == value.doc)
        end
      end
    end
  end
end
