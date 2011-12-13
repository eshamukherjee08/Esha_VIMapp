require 'spec_helper'

describe WalkinsController do
  
  render_views
  
  before do
    @event = mock_model(Event, :save => true, :id => 1,:event_date => Date.today + 1.day,
                            :name => "event1",
                            :experience => "fresher",
                            :location => "location1",
                            :description => "description1",
                            :category => "category1",
                            :tech_spec => "tech_spec1",
                            :admin_id => 1,
                            :batches_attributes => {'0' => { 'start_time' => Time.zone.now, 'end_time' => Time.zone.now + 1.hour , 'capacity' => 20, 'event_id '=> 1},
                                                    '1' => { 'start_time' => Time.zone.now + 1.hour + 1.minute , 'end_time' => Time.zone.now + 2.hour + 1.minute , 'capacity' => 20, 'event_id '=> 1}}
                          )
                          
    @events = [@event]
    @admin = mock_model(Admin, :id =>1, :email => 'esha.dummy@gmail.com', :password => 'password', :password_confirmation => 'password')
    controller.stub!(:current_admin).and_return(@admin)
    controller.stub!(:admin_signed_in?).and_return(true)
  end
  
  
  describe "INDEX" do

     it "get request should be successful" do

       Event.should_receive(:where).and_return(@events)

       get :index
       response.should be_success
       response.should render_template("index")
     end
  end
  
end