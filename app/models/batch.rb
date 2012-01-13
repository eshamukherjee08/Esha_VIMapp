class Batch < ActiveRecord::Base
  
  #associations of batch model.
  belongs_to :event
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  attr_accessible :capacity, :start_time, :end_time, :event_id
end
