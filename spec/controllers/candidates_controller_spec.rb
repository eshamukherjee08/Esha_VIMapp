require 'spec_helper'

describe CandidatesController do
  
  render_views
  
  before do
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
   @candidates = [@candidate] 
  end
  
  describe "INDEX" do
    
    it "get request should be successful" do
      
      Candidate.should_receive(:where).and_return(@candidates)

      get :index
      response.should be_success
      response.should render_template("index")
    end
  end
  
end