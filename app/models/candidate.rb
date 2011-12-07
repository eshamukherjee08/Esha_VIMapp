class Candidate < ActiveRecord::Base
  has_many :events_candidates
  has_many :events, :through => :events_candidates
  belongs_to :batch
  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  has_attached_file :resume, :styles => { :medium => "150x150>", :thumb => "100x100#" }
end
