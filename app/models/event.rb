class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches, :dependent => :destroy
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  #has_and_belongs_to_many :candidates
  validates_associated :batches
  validate :event_date, :presence => true, :uniqueness => true, :message => "Date cannot be empty, Please select a Date!"
  validate :name, :presence => true, :message => "Please enter event name."
  validate :experience, :presence => true, :message => "Please select Experience required for Walk-in."
  validate :location, :presence => true, :message => "Please select Location of Walk-in."
  validate :description, :presence => true, :message => "Please provide Description of event."
  validate :category, :presence => true, :message => "Please provide Category of event."
  validate :tech_spec, :presence => true, :message => "Please provide technical specifications for event."
  
  attr_accessible :batches_attributes
end
