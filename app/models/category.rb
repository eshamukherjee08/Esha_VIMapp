class Category < ActiveRecord::Base
  has_many :events
  validates :name, :presence => true
  
  def all_candidates
    EventsCandidate.where("event_id IN(#{events.map {|u| u.id.to_i}.join(",")})")
  end
  
end
