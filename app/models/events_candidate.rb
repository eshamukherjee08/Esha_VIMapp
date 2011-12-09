class EventsCandidate < ActiveRecord::Base
  belongs_to :event
  belongs_to :candidate
end
