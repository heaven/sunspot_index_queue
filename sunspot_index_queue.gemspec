# -*- encoding: utf-8 -*-
# stub: sunspot_index_queue 1.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sunspot_index_queue".freeze
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brian Durand".freeze]
  s.date = "2012-06-19"
  s.description = "This gem provides asynchronous indexing to Solr for the sunspot gem. It uses a pluggable model for the backing queue and provides support for ActiveRecord, DataMapper, and MongoDB out of the box.".freeze
  s.email = "brian@embellishedvisions.com".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = [".travis.yml".freeze, "CHANGE_LOG.txt".freeze, "MIT_LICENSE".freeze, "README.rdoc".freeze, "Rakefile".freeze, "VERSION".freeze, "lib/sunspot/index_queue.rb".freeze, "lib/sunspot/index_queue/batch.rb".freeze, "lib/sunspot/index_queue/entry.rb".freeze, "lib/sunspot/index_queue/entry/active_record_impl.rb".freeze, "lib/sunspot/index_queue/entry/data_mapper_impl.rb".freeze, "lib/sunspot/index_queue/entry/mongo_impl.rb".freeze, "lib/sunspot/index_queue/entry/redis_impl.rb".freeze, "lib/sunspot/index_queue/session_proxy.rb".freeze, "lib/sunspot_index_queue.rb".freeze, "spec/active_record_impl_spec.rb".freeze, "spec/batch_spec.rb".freeze, "spec/data_mapper_impl_spec.rb".freeze, "spec/entry_impl_examples.rb".freeze, "spec/entry_spec.rb".freeze, "spec/index_queue_spec.rb".freeze, "spec/integration_spec.rb".freeze, "spec/mongo_impl_spec.rb".freeze, "spec/redis_impl_spec.rb".freeze, "spec/session_proxy_spec.rb".freeze, "spec/spec_helper.rb".freeze, "sunspot_index_queue.gemspec".freeze]
  s.homepage = "http://github.com/bdurand/sunspot_index_queue".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze, "--main".freeze, "README.rdoc".freeze, "MIT_LICENSE".freeze]
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Asynchronous Solr indexing support for the sunspot gem with an emphasis on reliablity and throughput.".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sunspot>.freeze, [">= 1.1.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 2.2"])
      s.add_development_dependency(%q<dm-core>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-aggregates>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-migrations>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<mongo>.freeze, [">= 2.4.0"])
      s.add_development_dependency(%q<redis>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["< 3.0.0"])
      s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
    else
      s.add_dependency(%q<sunspot>.freeze, [">= 1.1.0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord>.freeze, [">= 2.2"])
      s.add_dependency(%q<dm-core>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<dm-aggregates>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<dm-migrations>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<mongo>.freeze, [">= 2.4.0"])
      s.add_dependency(%q<redis>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["< 3.0.0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_dependency(%q<byebug>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<sunspot>.freeze, [">= 1.1.0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 2.2"])
    s.add_dependency(%q<dm-core>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<dm-aggregates>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<dm-migrations>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<dm-sqlite-adapter>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<mongo>.freeze, [">= 2.4.0"])
    s.add_dependency(%q<redis>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["< 3.0.0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
  end
end
