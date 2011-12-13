require 'spec_helper'

describe Batch do
  
  
  before(:each) do
    @valid_attributes = {
     :start_time => Time.zone.now, 
     :end_time => Time.zone.now + 1.hour , 
     :capacity => 20, 
     :event_id => 1
    }
  
    @batch1 = Batch.new(@valid_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    @batch1.should be_valid
  end
  
  it "should have one event" do
    @batch1.should belong_to(:event)
  end
  
  it "should have many batches" do
    @batch1.should have_many(:candidates).through(:events_candidates)
  end
  
  it "should have many events_candidates" do
    @batch1.should have_many(:events_candidates)
  end
end