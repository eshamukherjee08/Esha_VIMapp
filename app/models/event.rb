class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  has_many :events_candidates
  has_many :candidates, :through => :events_candidates
  validates_associated :batches
  validates :event_date, :presence => true, :uniqueness => true
  validates :experience, :name, :location, :description, :candidates, :tech_spec, :presence => true
end
