class EventsCandidate < ActiveRecord::Base
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  scope :not_cancelled, where(:cancellation => false)
  
  def marking_attendance(events_candidates)
    unless events_candidates.empty?
      events_candidates.update_all :attended => true
    end
  end
  
end
