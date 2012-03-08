class Candidate < ActiveRecord::Base
  
  has_many :events_candidates , :dependent => :destroy

  has_many :events, :through => :events_candidates
  
  has_many :batches, :through => :events_candidates
  

  accepts_nested_attributes_for :events_candidates
    
  validates :terms, :acceptance => true 
  validates :address, :dob, :residing_state, :presence => true
  validates :email, :format => { :with =>  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ }, :uniqueness => true
  validates :mobile_number, :format => { :with => /\A[0-9]{10}\Z/}, :uniqueness => true
  validates :name, :home_town, :format => {:with => /\w+(\s\w+)*/}
  
  validates_associated :events_candidates
  
  before_create :generate_token
    
  scope :starred, where(:starred => true)
    
  
  #assigning candidate to a batch.
  def assign_to_batch(eventid, candidate, events_candidate)
    event = Event.where(:id => eventid).first
    events_candidate.roll_num = UUID.new.generate.hex
    
    if (event.capacity_full?)
      events_candidate.allot_waitlist!      # AASM state
    else
      event.find_empty_batch.events_candidates << events_candidate
      events_candidate.allot!              ## AASM state
    end
  end
  
  
  #send confirmation mail to candidate on registration.
  def self.send_confirmation_mail(candidate, event_id)   #need event for mail, have to paas event explicitely so not in callback.
    CandidateMailer.confirm_email(candidate, event_id).deliver
  end
  
  # generating unique perishable token for candidate.
  def generate_token
    self.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
  end
  
  def mark_star
    update_attributes(:starred => true)
  end
  
  # events_candidates.where(:event_id => event.id).first.cancel!
  def cancel_registeration(event)
    events_candidates.where(:event_id => event.id).first.cancel!
  end
  
  def select!(event)
    events_candidates.where(:event_id => event.id).first.select!
  end
  
  def reject!(event)
    events_candidates.where(:event_id => event.id).first.reject!
  end
  
  def status_change!(event)
    events_candidates.where(:event_id => event.id).first.change_status!
  end
  
end