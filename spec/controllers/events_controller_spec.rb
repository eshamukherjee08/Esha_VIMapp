require 'spec_helper'

describe EventsController do
  
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
                          
    @events_candidate = mock_model(EventsCandidate, :save => true, :id => 1,
                        :event_id => 1,
                        :candidate_id => 1,
                        :roll_num => 66778833,
                        :confirmed => true,
                        :attended => false,
                        :waitlist => false,
                        :cancellation => false,
                        :batch_id => 1,
                        :status => false)
    @events = [@event]
    @events_candidates = [@events_candidate]
    @admin = mock_model(Admin, :id =>1, :email => 'esha.dummy@gmail.com', :password => 'password', :password_confirmation => 'password')
    controller.stub!(:find_event).and_return(@event)
    controller.stub!(:current_admin).and_return(@admin)
    # @events_candidates.stub!(:not_cancelled).and_return(@events_candidates)
  end
    
  describe "INDEX" do
    
    it "get request should be successful" do
      
      Event.should_receive(:where).and_return(@events)

      get :index
      response.should be_success
      response.should render_template("index")
    end
    
    # it "should redirect to login page if admin is not logged in" do
    #   controller.should_receive(:current_admin).and_return(nil)
    #   
    #   get :index
    #   response.should redirect_to root_path
    #   flash[:notice].should == "Please log in"
    # end
    
  end

  describe "SHOW" do
    
    it "should find a record and render show template" do
         Event.should_receive(:where).and_return(@events).stub!(:first).and_return(@event)
         @event.stub!(:events_candidates).and_return(@events_candidates)
         get :show, :id => 1
         response.should be_success
         response.should render_template("show")
    end
  #   
    # it "should redirect to root path id end is not found" do
    #   Event.should_receive(:where).and_return([]).stub!(:first).and_return(nil)
    #   
    #   
    #   get :show, :id => 2
    #   response.should redirect_to error_walkins_path
    #   flash[:notice].should == "NOT FOUND"
    # end
  end
  
  describe "PAST" do

     it "get request should be successful" do

       Event.should_receive(:where).and_return(@events)

       get :past
       response.should be_success
       response.should render_template("past")
     end

   end
   
   # describe "DELETE destroy" do
   #    it "destroys the requested article" do
   #      event = @event
   #      expect {
   #        delete :destroy, :id => event.id
   #      }.to change(Event, :count).by(-1)
   #    end
   #  
   #    it "redirects to the articles list" do
   #      event = @event
   #      delete :destroy, :id => event.id
   #      response.should redirect_to(events_path)
   #    end
   #  end

   
  
end