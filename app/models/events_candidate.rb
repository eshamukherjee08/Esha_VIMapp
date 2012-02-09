## use AASM callbacks
class EventsCandidate < ActiveRecord::Base
  
  include AASM
  
  #associations for EventsCandidate model used in has_many_through.
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  #scope to find candidates who has not cancelled candidature.
  scope :not_cancelled, where("current_state in ('alloted','selected','rejected', 'attended')")
  
  #for marking attendance of attenting candidates.
  def marking_attendance(events_candidates)
    unless events_candidates.empty?
      events_candidates.each do |element|
        element.attend!
      end
    end
  end
  
  #sending mail to admin if candidature ia cancelled.
  def self.send_mail_after_cancel(events_candidate)
    AdminMailer.cancel_notification(events_candidate).deliver
  end
  
  
  aasm :column => :current_state do
    
    state :confirmed, :initial => true
    state :waitlisted
    state :attended
    state :cancelled
    state :alloted
    state :selected
    state :rejected
    
    event :allot do
      transitions :to => :alloted, :from => [:confirmed, :waitlisted]
    end
    
    event :allot_waitlist do
      transitions :to => :waitlisted, :from => [:confirmed]
    end
    
    event :cancel do
      transitions :to => :cancelled, :from => [:alloted, :waitlisted]
    end
    
    event :attend do
      transitions :to => :attended, :from => [:alloted]
    end
    
    event :select do
      transitions :to => :selected, :from => [:attended]
    end
    
    event :reject do
      transitions :to => :rejected, :from => [:attended]
    end
    
    event :edit_status do
      transitions :to => :attended, :from => [:selected, :rejected]
    end
  end
  
end
