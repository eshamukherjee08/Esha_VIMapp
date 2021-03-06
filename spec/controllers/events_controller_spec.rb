require 'spec_helper'
require 'nested_form'

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
    
    @batch = mock_model(Batch, :save => true, :id => 1, :start_time => Time.zone.now, :end_time => Time.zone.now + 1.hour, :capacity => 20)
                          
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

    
    @candidate = mock_model(Candidate, :save => true, :id => 1,
                          :name => "candidate1",
                          :dob => DateTime.new(1988,2,8),
                          :address => "address1",
                          :current_state => "current_state1",
                          :home_town => "home_town1",
                          :mobile_number => 01234567,
                          :exp => "fresher",
                          :salary_exp => ">5 L.P.A",
                          :starred => false,
                          :email => "esha@example.com",
                          :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
                          :perishable_token => Digest::MD5.hexdigest("#{Time.now}"))
                          
    
    controller.stub!(:current_admin).and_return(@admin)

    @event.stub!(:batches).and_return([@batch])

  end
  

    
  describe "INDEX" do
    
    it "get request should be successful" do
      
      Event.should_receive(:upcoming_events).and_return(@events)
      @events.should_receive(:order).and_return(@events)
      
      
      get :index
      response.should be_success
      response.should render_template("index")
    end
    
    it "should redirect to login page if admin is not logged in" do
      controller.should_receive(:current_admin).and_return(nil)
      
      get :index
      response.should redirect_to root_path
      flash[:notice].should == "Please log in"
    end
    
  end

  describe "SHOW" do
    
    it "should find a record and render show template" do
       Event.should_receive(:where).and_return(@events)
       @events.should_receive(:first).and_return(@event)
       
       @event.should_receive(:events_candidates).and_return(@events_candidates)
       @events_candidates.should_receive(:not_cancelled).and_return(@events_candidates)
       
       @events_candidate.should_receive(:candidate).and_return(@candidate)
       
       get :show, :id => @event.id
       response.should be_success
       response.should render_template("show")
    end
    
    it "should redirect to root path id if is not found" do
      Event.should_receive(:where).and_return([]).stub!(:first).and_return(nil)
      
      get :show, :id => 8
      response.should redirect_to error_walkins_path
      flash[:notice].should == "NOT FOUND"
    end

  end
  
  describe "NEW" do
    
    it "get request should be successful" do
      get :new
      response.should be_success
      assigns(:event).should be_a_new(Event)
      response.should render_template("new")
    end
  end
  
  describe "CREATE" do
    
    describe "with valid parameters" do
      
      it "should create a record" do
        valid_attr = {:event => { :event_date => "01/04/2012",
                       :name => "eventA",
                       :experience => "fresher",
                       :location => "locationA",
                       :description => "description1",
                       :category => "categoryA",
                       :tech_spec => "tech_specA",
                       :admin_id => 1,
                       :batches_attributes => {'0' => { 'start_time' => Time.zone.now, 'end_time' => Time.zone.now + 1.hour , 'capacity' => 20, 'event_id '=> 1},
                                              '1' => { 'start_time' => Time.zone.now + 1.hour + 1.minute , 'end_time' => Time.zone.now + 2.hour + 1.minute , 'capacity' => 20, 'event_id '=> 1}} }}
        e = mock_model(Event, valid_attr)
        Event.should_receive(:new).and_return(e)
        e.should_receive(:save).and_return(true)
      
        post :create, valid_attr
        response.should be_redirect
        response.should redirect_to events_path
        flash[:notice].should == "Event was successfully created."
      end
    end
  end
  
  describe "PAST" do

     it "get request should be successful" do
       Event.should_receive(:past_events).and_return(@events)
       @events.should_receive(:order).and_return(@events)

       get :past
       response.should be_success
       response.should render_template("past")
     end

  end
  
  describe "UPDATE" do
    
    describe "with valid params" do
      
      it "should update the user given valid id" do
        Event.should_receive(:where).and_return(@event)
        @event.stub!(:first).and_return(@event)
        @event.stub!(:update_attributes).and_return true
        
        put :update, :id => 1, :event => { :name => "event2", :experience => "fresher" }
        response.should be_redirect
        response.should redirect_to events_path
        flash[:notice].should == "Event was successfully updated."
      end
      
      it "should redirect to root given invalid id" do
        Event.should_receive(:where).and_return(Array.new)
        Array.new.stub!(:first).and_return(nil)
        
        put :update, :id => 4, :event => { :name => "user2" }
        response.should be_redirect
        response.should redirect_to error_walkins_path
        flash[:notice].should == "NOT FOUND"
      end
      
    end
    
    describe "with invalid params" do
      
      # it "should render edit template" do
      #   Event.should_receive(:where).and_return(@event)
      #   @event.stub!(:first).and_return(@event)
      #   @event.stub!(:update_attributes).and_return false
      #   
      #   put :update, :id => 1, :event => {:name => "" }
      #   response.should be_success
      #   response.should render_template("edit")
      # end
    end
  end
end