class Category < ActiveRecord::Base
  has_many :events
  validates :name, :presence => true
  
  
  def find_all_candidates
    self.events.collect{|e| e.candidates}.first
  end
  
end
