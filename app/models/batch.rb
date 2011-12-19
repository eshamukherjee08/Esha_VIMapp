class Batch < ActiveRecord::Base
  belongs_to :event
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  attr_accessible :capacity, :start_time, :end_time
  validates :capacity, :presence => true, :message => "Please provide Capacity of event."
  validates :capacity, :presence => true, :message => "Capacity should be number."
    
  before_destroy :check_allocation
  
  private
  
   def check_allocation
      p "XXXXXXXXXXXXXXXXXXXXXX"
  end
end
