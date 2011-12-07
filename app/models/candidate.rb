class Candidate < ActiveRecord::Base
  has_many :events
  belongs_to :batch
  validate :name, :presence => true
  validate :email, :presence => true
  has_attached_file :resume, :styles => { :medium => "150x150>", :thumb => "100x100#" }
end
