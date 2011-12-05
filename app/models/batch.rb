class Batch < ActiveRecord::Base
  belongs_to :event
  #has_many :candidates
  validate :capacity, :presence => true, :message => "Please provide Capacity of event."
  validate :capacity, :presence => true, :message => "Capacity should be number."
end
