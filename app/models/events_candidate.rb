class EventsCandidate < ActiveRecord::Base
  
  include AASM  
  
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  delegate :experience, :to => :event
  
  has_attached_file :resume
  
  validates :salary_exp, :presence => true
  validates_attachment_presence :resume
  validates_attachment_content_type :resume, :content_type =>['text/plain', 'application/rtf', 'application/x-pdf', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  
  #scope to find candidates who has confirmed candidature.
  scope :valid, where("state in ('alloted','selected','rejected', 'attended')")
  
  scope :waitlist, where(:state => :waitlisted)
  
  scope :star, where("candidate_id IN(#{Candidate.starred.map {|u| u.id.to_i}.join(",")})")
  
  def self.mark_attendance(events_candidates)
    events_candidates.each do |element|
      element.attend!
    end
  end
  
  
  aasm_column :state
    
  aasm_initial_state :registered
  aasm_state :registered
  aasm_state :waitlisted
  aasm_state :attended
  aasm_state :cancelled
  aasm_state :alloted
  aasm_state :selected
  aasm_state :rejected
  
  aasm_event :allot do
    transitions :to => :alloted, :from => [:registered]
  end
  
  aasm_event :allot_batch, :after => :allocation_notfification do
    transitions :to => :alloted, :from => [:waitlisted]
  end
  
  aasm_event :allot_waitlist do
    transitions :to => :waitlisted, :from => [:registered]
  end
  
  aasm_event :cancel, :after => :after_cancel do
    transitions :to => :cancelled, :from => [:alloted, :waitlisted]
  end
  
  aasm_event :attend do
    transitions :to => :attended, :from => [:alloted]
  end
  
  aasm_event :select do
    transitions :to => :selected, :from => [:attended]
  end
  
  aasm_event :reject do
    transitions :to => :rejected, :from => [:attended]
  end
  
  aasm_event :change_status do
    transitions :to => :attended, :from => [:selected, :rejected]
  end
  
  
  #send mail to admin and updation after cancel.
  def after_cancel
    AdminMailer.cancel_notification(self).deliver
    self.update_attributes(:batch_id => nil)
    self.event.find_empty_batch.waitlist_allocation
  end
  
  
  # send mail to candidate after waitlist confirmation.
  ## allocation_notfification
  def allocation_notfification
    CandidateMailer.allocation_email(self).deliver
  end
  
  # Remove

  
  def can_cancel?
    event.scheduled_at.future? or event.scheduled_at.today?
  end
  
end
