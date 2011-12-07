class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  has_many :events_candidates
  has_many :candidates, :through => :events_candidates
  validates_associated :batches
  validates :event_date, :presence => true, :uniqueness => true, :message => "Date cannot be empty, Please select a Date!"
  validates :name, :presence => true, :message => "Please enter event name."
  validates :experience, :presence => true, :message => "Please select Experience required for Walk-in."
  validates :location, :presence => true, :message => "Please select Location of Walk-in."
  validates :description, :presence => true, :message => "Please provide Description of event."
  validates :category, :presence => true, :message => "Please provide Category of event."
  validates :tech_spec, :presence => true, :message => "Please provide technical specifications for event."
end
