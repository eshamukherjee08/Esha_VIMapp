## use AASM callbacks
class EventsCandidate < ActiveRecord::Base
  
  include AASM   # using acts_as_state_machine
  
  #associations for EventsCandidate model used in has_many_through.
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  #scope to find candidates who has not cancelled candidature.
  scope :not_cancelled, where("current_state in ('alloted','selected','rejected', 'attended')")
  
  #for marking attendance of attenting candidates.
  ## unless not required
  def self.marking_attendance(events_candidates)
    events_candidates.each do |element|
      element.attend!
    end
  end
  
  
  #aasm states and events declarations.

  aasm_column :current_state
    
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
  
  aasm_event :allot_batch, :after => :candidate_notify do
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
  
  aasm_event :edit_status do
    transitions :to => :attended, :from => [:selected, :rejected]
  end
  
  
  #send mail to admin and updation after cancel.
  def after_cancel
    AdminMailer.cancel_notification(self).deliver
    self.update_attributes(:batch_id => nil)
    # event.waitlist_allocation
    self.event.waitlist_allocation
  end
  
  
  # send mail to candidate after waitlist confirmation.
  ## should be after allocation
  def candidate_notify
    CandidateMailer.allocation_email(self).deliver
  end
  
end
