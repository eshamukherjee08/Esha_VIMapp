class Batch < ActiveRecord::Base
  belongs_to :event
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  attr_accessible :capacity, :start_time, :end_time
  validates :capacity, :presence => {:message => "Please provide Capacity of event." }
  validates :capacity, :presence =>  {:message => "Capacity should be number." }
end
