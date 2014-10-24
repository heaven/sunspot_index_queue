require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../entry_impl_examples', __FILE__)

describe Sunspot::IndexQueue::Entry::MongoImpl do

  before :all do
    Sunspot::IndexQueue::Entry.implementation = :mongo
    Sunspot::IndexQueue::Entry::MongoImpl.connection = ['localhost:27017']
    Sunspot::IndexQueue::Entry::MongoImpl.database_name = "sunspot_index_queue_test"

    Sunspot::IndexQueue::Entry::MongoImpl.collection.find.remove_all
  end

  after :all do
    Sunspot::IndexQueue::Entry.implementation = nil
  end

  let(:factory) do
    factory = Object.new

    def factory.create(attributes)
      Sunspot::IndexQueue::Entry::MongoImpl.create(attributes)
    end

    def factory.delete_all
      Sunspot::IndexQueue::Entry::MongoImpl.collection.find.remove_all
    end

    def factory.find(id)
      Sunspot::IndexQueue::Entry::MongoImpl.find_one(id)
    end

    factory
  end

  it_should_behave_like "Entry implementation"

end
