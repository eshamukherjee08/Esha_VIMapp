class Category < ActiveRecord::Base
  has_many :events, :dependent => :nullify # do
  #     def event_candidates
  #       EventsCandidate.where("event_id IN(#{self.collect(&:id)})")
  #     end
  # end
  validates :name, :presence => true

  #   rename
  def all_candidates
    EventsCandidate.where("event_id IN(#{events.map {|u| u.id.to_i}.join(',')})")
  end
  
end
