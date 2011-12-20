require 'spec_helper'

describe Candidate do
  
  
  before(:each) do
    @valid_attributes = {
      :name => "candidate",
      :dob => DateTime.new(1988,2,8),
      :address => "address1",
      :current_state => "current_state1",
      :home_town => "hometown",
      :mobile_number => 8826614708,
      :exp => "fresher",
      :salary_exp => ">5 L.P.A",
      :starred => false,
      :email => "esha@example.com",
      :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
      :perishable_token => Digest::MD5.hexdigest("#{Time.now}")
    }
  
    @candidate1 = Candidate.new(@valid_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    #p "******************"
    #p @candidate1.valid?
    #p @candidate1.errors.full_messages
    @candidate1.should be_valid
  end 
  
  describe 'Validation Of Resume' do
    
    it "should have an attached resume" do
      @candidate1.should have_attached_file(:resume)
    end
    
    
  end
  
  describe 'Validations' do
    
    it "should have a date of birth" do
      @candidate1.dob = DateTime.new(1988,8,18)
      @candidate1.should be_valid
    end
    
    it "should have a address" do
      @candidate1.should validate_presence_of(:address)
    end
    
    it "should have a current_state" do
      @candidate1.should validate_presence_of(:current_state)
    end
    
    it "should have a exp" do
      @candidate1.should validate_presence_of(:exp)
    end
    
    it "should have a salary_exp" do
      @candidate1.should validate_presence_of(:salary_exp)
    end
    
    it "should validate format of email" do
      invalid_attr = { :name => "xyz",
      :dob => DateTime.new(1988,2,8),
      :address => "address1",
      :current_state => "current_state1",
      :home_town => "hometown",
      :mobile_number => 8826614708,
      :exp => "fresher",
      :salary_exp => ">5 L.P.A",
      :starred => false,
      :email => "esha@example",
      :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
      :perishable_token => Digest::MD5.hexdigest("#{Time.now}") }
      
      candidate = Candidate.new(invalid_attr)
      candidate.should_not be_valid
      candidate.should have(1).error_on(:email)
    end
    
    it "should have unique email address" do
      @candidate1.save
      @candidate2 = Candidate.new(:name => "xxx",
      :dob => DateTime.new(1988,2,8),
      :address => "address1",
      :current_state => "current_state1",
      :home_town => "hometowns",
      :mobile_number => 8826614703,
      :exp => "fresher",
      :salary_exp => ">5 L.P.A",
      :starred => false,
      :email => "esha@example",
      :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
      :perishable_token => Digest::MD5.hexdigest("#{Time.now}"))
      @candidate2.should_not be_valid
      @candidate2.should have(1).error_on(:email)
    end
    
    it "should validate format of mobile_number" do
      invalid_attr = { :name => "xyz",
      :dob => DateTime.new(1988,2,8),
      :address => "address1",
      :current_state => "current_state1",
      :home_town => "hometown",
      :mobile_number => 8826613,
      :exp => "fresher",
      :salary_exp => ">5 L.P.A",
      :starred => false,
      :email => "esha@example.in",
      :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
      :perishable_token => Digest::MD5.hexdigest("#{Time.now}") }
      candidate = Candidate.new(invalid_attr)
      candidate.should_not be_valid
      candidate.should have(1).error_on(:mobile_number)
    end
    
     it "should have unique mobile number" do
        @candidate1.save
        @candidate2 = Candidate.new(:name => "xxx",
        :dob => DateTime.new(1988,2,8),
        :address => "address1",
        :current_state => "current_state1",
        :home_town => "hometowns",
        :mobile_number => 8826614708,
        :exp => "fresher",
        :salary_exp => ">5 L.P.A",
        :starred => false,
        :email => "esha@example.in",
        :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
        :perishable_token => Digest::MD5.hexdigest("#{Time.now}"))
        @candidate2.should_not be_valid
        @candidate2.should have(1).error_on(:mobile_number)
      end
     
      it "should validate format of name" do
        invalid_attr = { :name => "xyz1",
        :dob => DateTime.new(1988,2,8),
        :address => "address1",
        :current_state => "current_state1",
        :home_town => "hometown",
        :mobile_number => 8826614708,
        :exp => "fresher",
        :salary_exp => ">5 L.P.A",
        :starred => false,
        :email => "esha@example.in",
        :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
        :perishable_token => Digest::MD5.hexdigest("#{Time.now}") }
        candidate = Candidate.new(invalid_attr)
        candidate.should_not be_valid
        candidate.should have(1).error_on(:name)
      end 
      
      it "should validate format of home town" do
        invalid_attr = { :name => "xyz",
        :dob => DateTime.new(1988,2,8),
        :address => "address1",
        :current_state => "current_state1",
        :home_town => "hometown12",
        :mobile_number => 8826614708,
        :exp => "fresher",
        :salary_exp => ">5 L.P.A",
        :starred => false,
        :email => "esha@example.in",
        :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
        :perishable_token => Digest::MD5.hexdigest("#{Time.now}") }
        candidate = Candidate.new(invalid_attr)
        candidate.should_not be_valid
        candidate.should have(1).error_on(:home_town)
      end
      
     it "should have resume with valid format" do
       invalid_attr = { :name => "xyz",
       :dob => DateTime.new(1988,2,8),
       :address => "address1",
       :current_state => "current_state1",
       :home_town => "hometown",
       :mobile_number => 8826614708,
       :exp => "fresher",
       :salary_exp => ">5 L.P.A",
       :starred => false,
       :email => "esha@example.in",
       :resume => File.new(Rails.root + "public/system/resumes/default.rb"),
       :perishable_token => Digest::MD5.hexdigest("#{Time.now}") }
       
       candidate = Candidate.new(invalid_attr)
       candidate.should_not be_valid
       candidate.should have(2).error_on(:resume)
     end
     

    
  end
  
  describe 'Relations' do
    
    it "should have many batches" do
      @candidate1.should have_many(:batches).through(:events_candidates)
    end

    it "should have many events_candidates" do
      @candidate1.should have_many(:events_candidates)
    end

    it "should have many events" do
      @candidate1.should have_many(:events).through(:events_candidates)
    end
  end
  
  # describe 'Methods' do
  #     
  #     it "should assign candidate to waitlist if batches full" do
  #       @candidate2 = {
  #         :name => "candidate2",
  #         :dob => DateTime.new(1988,2,8),
  #         :address => "address2",
  #         :current_state => "current_state2",
  #         :home_town => "home_town2",
  #         :mobile_number => 01234567,
  #         :exp => "fresher",
  #         :salary_exp => "5 L.P.A",
  #         :starred => false,
  #         :email => "e@example.com",
  #         :resume => File.new(Rails.root + "public/system/resumes/default.txt"),
  #         :perishable_token => Digest::MD5.hexdigest("#{Time.now}")
  #       }
  #       
  #       @event2 = {
  #         :event_date => Date.today + 1.day,
  #         :name => "event1",
  #         :experience => "fresher",
  #         :location => "location",
  #         :description => "description",
  #         :category => "category",
  #         :tech_spec => "tech_spec",
  #         :admin_id => 1,
  #         :batches_attributes => {'0' => { 'start_time' => Time.zone.now, 'end_time' => Time.zone.now + 1.hour , 'capacity' => 1, 'event_id '=> 1}}
  #       }
  #       
  #       @candidate2.assign_to_batch(@event2,@candidate2)
  #     end
  #   end
  
end