class Batch < ActiveRecord::Base
  belongs_to :event
  has_many :candidates
  validates :capacity, :presence => true, :message => "Please provide Capacity of event."
  validates :capacity, :presence => true, :message => "Capacity should be number."
end
