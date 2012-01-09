class EventsCandidate < ActiveRecord::Base
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  attr_accessible :event_id, :candidate_id, :roll_num, :confirmed, :attended, :waitlist, :cancellation, :batch_id, :status
  
  scope :not_cancelled, where(:cancellation => false, :waitlist => false )
  
  def marking_attendance(events_candidates)
    unless events_candidates.empty?
      events_candidates.update_all :attended => true
    end
  end
  
  def self.send_mail_after_cancel(events_candidate)
    AdminMailer.cancel_notification(events_candidate).deliver
  end
  
end
