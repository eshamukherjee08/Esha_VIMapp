class Batch < ActiveRecord::Base
  belongs_to :event
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  validates :capacity, :presence => true, :message => "Please provide Capacity of event."
  validates :capacity, :presence => true, :message => "Capacity should be number."
end
