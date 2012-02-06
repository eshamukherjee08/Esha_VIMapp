class Batch < ActiveRecord::Base
  
  belongs_to :event

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates :start_time, :end_time, :presence => true
  validates :capacity, :allow_nil => false, :numericality => true
  
end
## Add validations