class Batch < ActiveRecord::Base
  
  belongs_to :event

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates :start_time, :end_time, :presence => true
  validates :capacity, :allow_nil => false, :numericality => true
  
  validate :check_allocation
  
  #not to delete a batch if allocation started.
  def check_allocation
    if self.marked_for_destruction? and !self.candidates.count.zero?
      errors.add(:base, "CANNOT DELETE BATCH")
    end
  end
end