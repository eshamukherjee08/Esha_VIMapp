class EventsCandidate < ActiveRecord::Base
  belongs_to :event
  belongs_to :candidate
  belongs_to :batch
  
  scope :not_cancelled, where(:cancellation => false)
  
end
