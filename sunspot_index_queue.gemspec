# -*- encoding: utf-8 -*-
# stub: sunspot_index_queue 1.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sunspot_index_queue"
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brian Durand"]
  s.date = "2012-06-19"
  s.description = "This gem provides asynchronous indexing to Solr for the sunspot gem. It uses a pluggable model for the backing queue and provides support for ActiveRecord, DataMapper, and MongoDB out of the box."
  s.email = "brian@embellishedvisions.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = [".travis.yml", "CHANGE_LOG.txt", "MIT_LICENSE", "README.rdoc", "Rakefile", "VERSION", "lib/sunspot/index_queue.rb", "lib/sunspot/index_queue/batch.rb", "lib/sunspot/index_queue/entry.rb", "lib/sunspot/index_queue/entry/active_record_impl.rb", "lib/sunspot/index_queue/entry/data_mapper_impl.rb", "lib/sunspot/index_queue/entry/mongo_impl.rb", "lib/sunspot/index_queue/entry/redis_impl.rb", "lib/sunspot/index_queue/session_proxy.rb", "lib/sunspot_index_queue.rb", "spec/active_record_impl_spec.rb", "spec/batch_spec.rb", "spec/data_mapper_impl_spec.rb", "spec/entry_impl_examples.rb", "spec/entry_spec.rb", "spec/index_queue_spec.rb", "spec/integration_spec.rb", "spec/mongo_impl_spec.rb", "spec/redis_impl_spec.rb", "spec/session_proxy_spec.rb", "spec/spec_helper.rb", "sunspot_index_queue.gemspec"]
  s.homepage = "http://github.com/bdurand/sunspot_index_queue"
  s.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc", "MIT_LICENSE"]
  s.rubygems_version = "2.2.2"
  s.summary = "Asynchronous Solr indexing support for the sunspot gem with an emphasis on reliablity and throughput."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sunspot>, [">= 1.1.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 2.2"])
      s.add_development_dependency(%q<dm-core>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-aggregates>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-migrations>, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
      s.add_development_dependency(%q<mongo>, [">= 0"])
      s.add_development_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<sunspot>, [">= 1.1.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.2"])
      s.add_dependency(%q<dm-core>, [">= 1.0.0"])
      s.add_dependency(%q<dm-aggregates>, [">= 1.0.0"])
      s.add_dependency(%q<dm-migrations>, [">= 1.0.0"])
      s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
      s.add_dependency(%q<mongo>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<sunspot>, [">= 1.1.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.2"])
    s.add_dependency(%q<dm-core>, [">= 1.0.0"])
    s.add_dependency(%q<dm-aggregates>, [">= 1.0.0"])
    s.add_dependency(%q<dm-migrations>, [">= 1.0.0"])
    s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.0.0"])
    s.add_dependency(%q<mongo>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
