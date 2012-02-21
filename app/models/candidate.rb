class Candidate < ActiveRecord::Base
  
  #associations of candidate model.
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
 
  has_attached_file :resume
  
  #validations for candidate model.
  
  #for term acceptance in registration form.
  validates :terms, :acceptance => true
 
  validates :address, :dob, :current_state, :exp, :salary_exp, :presence => true
 
  validates_attachment_presence :resume
  
  validates_attachment_content_type :resume, :content_type =>['text/plain', 'application/rtf', 'application/x-pdf', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
 
  validates :email, :format => { :with =>  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ }, :uniqueness => true
 
  validates :mobile_number, :format => { :with => /\A[0-9]{10}\Z/}, :uniqueness => true
 
  validates :name, :home_town, :format => {:with => /\w+(\s\w+)*/}
 
    
    #send confirmation mail to candidate on registration.
    # Can we move this to callbacks
    def self.send_confirmation_mail(candidate, event_id)
      CandidateMailer.confirm_email(candidate, event_id).deliver
    end
    
    #generating unique perishable token for candidate.
    def self.generate_token
      Digest::MD5.hexdigest("#{Time.now}")
    end
    
    
    #assigning candidate to a batch.
    # Select batch function
    # Create funtion in event to check all batches full
    ## Please see this optimization
    ## Dont create EventsCandidate explicitly => put in before save
    ## waitlist allocation => after save
    def assign_to_batch(eventid,candidate)
      event = Event.where(:id => eventid).first
      events_candidate = EventsCandidate.new(:event_id => eventid, :candidate_id => candidate.id, :roll_num => UUID.new.generate.hex)
      ## if capacity is full
      if (event.check_capacity(event))
        events_candidate.allot_waitlist!
        events_candidate.save
      else
        batch = event.find_batch(event)
        events_candidate.batch_id = batch.id
        events_candidate.allot!
        events_candidate.save
      end
    end
end
