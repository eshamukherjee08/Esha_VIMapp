class Batch < ActiveRecord::Base
  
  belongs_to :event

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  ## We dont need attr_accessible here
  attr_accessible :capacity, :start_time, :end_time, :event_id
end
