class Category < ActiveRecord::Base
  has_many :events, :dependent => :nullify # do
   # #no such column: 1: SELECT  "events_candidates".* FROM "events_candidates" WHERE (event_id IN([1])) LIMIT 10 OFFSET 0
  #     def event_candidates
  #       EventsCandidate.where("event_id IN(#{self.map(&:id)})")
  #     end
  #   end
  validates :name, :presence => true

  #   rename
  def all_events_candidates
    p EventsCandidate.where("event_id IN(#{events.map {|u| u.id.to_i}.join(',')})")
  end
  
end
