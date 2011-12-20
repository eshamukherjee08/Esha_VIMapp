require 'spec_helper'

describe Event do
  
  
  before(:each) do
    @valid_attributes = {
      :event_date => Date.today + 1.day,
      :name => "event1",
      :experience => "fresher",
      :location => "location1",
      :description => "description1",
      :category => "category1",
      :tech_spec => "tech_spec1",
      :admin_id => 1,
      :batches_attributes => {'0' => { 'start_time' => Time.zone.now, 'end_time' => Time.zone.now + 1.hour , 'capacity' => 20, 'event_id '=> 1}}
    }
  
    @event1 = Event.new(@valid_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    p @event1.valid?
    p @event1.errors.full_messages
    @event1.should be_valid
  end
  
  
  it "should have a name" do
    @event1.should validate_presence_of(:name)
  end
  
  it "should have a event_date" do
    @event1.should validate_presence_of(:event_date)
  end
  
  it "should have a experience" do
    @event1.should validate_presence_of(:experience)
  end
  
  it "should have a location" do
    @event1.should validate_presence_of(:location)
  end
  
  it "should have a description" do
    @event1.should validate_presence_of(:description)
  end
  
  it "should have a category" do
    @event1.should validate_presence_of(:category)
  end
  
  it "should have a tech_spec" do
    @event1.should validate_presence_of(:tech_spec)
  end
  
  it "should accept nested attributes for batches" do
    @event1.respond_to?('batches_attributes=').should be_true
  end
  
  it "should have one admin" do
    @event1.should belong_to(:admin)
  end
  
  it "should have many batches" do
    @event1.should have_many(:batches)
  end
  
  it "should have many events_candidates" do
    @event1.should have_many(:events_candidates)
  end
  
  it "should have many candidates" do
    @event1.should have_many(:candidates)
  end
  
  it "includes events created after or at current time" do
    e = Event.create!(:event_date => Time.zone.now + 1.day ,
      :name => "event1",
      :experience => "fresher",
      :location => "location1",
      :description => "description1",
      :category => "category1",
      :tech_spec => "tech_spec1",
      :admin_id => 1,
      :batches_attributes => {'0' => { 'start_time' => Time.zone.now, 'end_time' => Time.zone.now + 1.hour , 'capacity' => 20, 'event_id '=> 1}} )
    e.should be_valid
  end
end