class Event < ActiveRecord::Base
  belongs_to :admin

  has_many :batches, :dependent => :destroy
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  #has_and_belongs_to_many :candidates
  has_many :events_candidates
  has_many :candidates, :through => :events_candidates

  validates_associated :batches

  validates :event_date, :presence => true, :uniqueness => true
  validates :experience, :name, :location, :description, :candidates, :tech_spec, :presence => true
  
  attr_accessible :batches_attributes
end
