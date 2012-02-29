class Category < ActiveRecord::Base
  has_many :events
  validates :name, :presence => true
  
  
  def all_candidates
    events.collect{|e| e.candidates}.flatten
  end
  
end
