class EventsCandidate < ActiveRecord::Base
  
  #associations for EventsCandidate model used in has_many_through.
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  ## We dont need attr_accessible
  attr_accessible :event_id, :candidate_id, :roll_num, :confirmed, :attended, :waitlist, :cancellation, :batch_id, :status
  
  #scope to find candidates who has not cancelled candidature.
  scope :not_cancelled, where(:cancellation => false, :waitlist => false )
  
  #for marking attendance of attenting candidates.
  def marking_attendance(events_candidates)
    unless events_candidates.empty?
      events_candidates.update_all :attended => true
    end
  end
  
  #sending mail to admin if candidature ia cancelled.
  def self.send_mail_after_cancel(events_candidate)
    AdminMailer.cancel_notification(events_candidate).deliver
  end
  
end
