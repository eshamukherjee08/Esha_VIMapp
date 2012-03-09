class Category < ActiveRecord::Base

  has_many :events, :dependent => :nullify  do
    def event_candidates
      EventsCandidate.where(:event_id => self.map(&:id))
    end
  end

  validates :name, :presence => true
  
end
