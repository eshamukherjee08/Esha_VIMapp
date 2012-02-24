class Candidate < ActiveRecord::Base
  
  #associations of candidate model.
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
  accepts_nested_attributes_for :events_candidates
  
  #validations for candidate model.
  
  #for term acceptance in registration form.
  validates :terms, :acceptance => true
 
  validates :address, :dob, :current_state, :presence => true
 
  validates :email, :format => { :with =>  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ }, :uniqueness => true
 
  validates :mobile_number, :format => { :with => /\A[0-9]{10}\Z/}, :uniqueness => true
 
  validates :name, :home_town, :format => {:with => /\w+(\s\w+)*/}
  
  validates_associated :events_candidates
  
  before_create :generate_token
  
  scope :starred, where(:starred => true)
    
  #assigning candidate to a batch.
  ## waitlist allocation => after save
  def assign_to_batch(eventid,candidate,events_candidate)
    event = Event.where(:id => eventid).first
    events_candidate.roll_num = UUID.new.generate.hex
    ## if capacity is full
    if (event.check_capacity(event))
      events_candidate.allot_waitlist!
      events_candidate.save
    else
      batch = event.find_batch(event)
      batch.events_candidates << events_candidate
      events_candidate.allot!
      events_candidate.save
    end
  end
  
  
  #send confirmation mail to candidate on registration.
  # Can we move this to callbacks
  def self.send_confirmation_mail(candidate, event_id)
    CandidateMailer.confirm_email(candidate, event_id).deliver
  end
  
  #generating unique perishable token for candidate.
  def generate_token
    self.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
  end
  
  def mark_star
    update_attributes(:starred => true)
  end
  
  def resume_download
    send_file(self.resume.path , :content_type => self.resume_content_type)
  end
  
  def selected(events_candidate)
    events_candidate.select!
  end
  
  def rejected(events_candidate)
    events_candidate.reject!
  end
  
  # def status_edit(events_candidate)
  #   events_candidate.edit_status!
  # end
  
end