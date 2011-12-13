require 'spec_helper'

describe EventsCandidate do
  
  
  before(:each) do
    @valid_attributes = {
     :event_id => 1,
     :candidate_id => 1,
     :roll_num => 66778833,
     :confirmed => true,
     :attended => false,
     :waitlist => false,
     :cancellation => false,
     :batch_id => 1,
     :status => false
    }
  
    @events_candidate1 = Batch.new(@valid_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    @events_candidate1.should be_valid
  end
  
  it "should have one event" do
    @events_candidate1.should belong_to(:event)
  end
  
  # it "should have one candidate" do
  #   @events_candidate1.should belong_to(:candidate)
  # end
  # 
  # it "should have one batch" do
  #   @events_candidate1.should belong_to(:batch)
  # end
end