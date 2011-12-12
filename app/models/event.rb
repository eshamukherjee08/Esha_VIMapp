class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches, :dependent => :destroy
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  #has_many :batches, :through => :events_candidates
  
  validates_associated :batches
  attr_accessible :batches_attributes, :event_date, :category, :name, :description, :tech_spec, :experience, :location, :admin_id
  validates :event_date, :presence => true
  validates :experience, :name, :location, :description, :category, :tech_spec, :presence => true
  attr_accessible :cb_attend
end
