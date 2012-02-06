class Candidate < ActiveRecord::Base
  
  #associations of candidate model.
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
 
  has_attached_file :resume
  
  #validations for candidate model.
  
  #for term acceptance in registration form.
  validates_acceptance_of :terms
 
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
    
    def assign_to_batch(event,candidate)
      events_candidate = EventsCandidate.where(:event_id => event.id , :candidate_id => candidate.id )
      if (event.batches.sum(:capacity) <= event.candidates.count )
        @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
        @events_candidate.save
      else
        # Remove flag
        flag = true
        event.batches.each do |batch|
          while(batch.capacity != batch.candidates.count && flag )
            @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
            @events_candidate.save
            flag = false
          end
        end
      end
    end
end
