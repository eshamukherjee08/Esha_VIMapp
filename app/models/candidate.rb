class Candidate < ActiveRecord::Base
  
  #associations of candidate model.
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  
  has_many :batches, :through => :events_candidates
  
  accepts_nested_attributes_for :events_candidates
    
  #for term acceptance in registration form.
  validates :terms, :acceptance => true
 
  validates :address, :dob, :residing_state, :presence => true
 
  validates :email, :format => { :with =>  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ }, :uniqueness => true
 
  validates :mobile_number, :format => { :with => /\A[0-9]{10}\Z/}, :uniqueness => true
 
  validates :name, :home_town, :format => {:with => /\w+(\s\w+)*/}
  
  validates_associated :events_candidates
  
  before_create :generate_token
    
  scope :starred, where(:starred => true)
    
  #assigning candidate to a batch.
  ## waitlist allocation => after save
  def assign_to_batch(eventid, candidate, events_candidate)
    event = Event.where(:id => eventid).first
    events_candidate.roll_num = UUID.new.generate.hex
    if (event.capacity_full?)
      events_candidate.allot_waitlist!      
    else
      event.find_empty_batch.events_candidates << events_candidate
      events_candidate.allot!
    end
  end
  
  
  #send confirmation mail to candidate on registration.
  # Can we move this to callbacks
  def self.send_confirmation_mail(candidate, event_id)   #need event for mail, have to paas event explicitely so not in callback.
    CandidateMailer.confirm_email(candidate, event_id).deliver
  end
  
  #generating unique perishable token for candidate.
  def generate_token
    self.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
  end
  
  def mark_star
    update_attributes(:starred => true)
  end
  
  def cancel_registeration(event)
    EventsCandidate.where(:event_id => event.id, :candidate_id => id).first.cancel!
  end
  
end