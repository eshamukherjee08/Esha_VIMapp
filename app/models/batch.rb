class Batch < ActiveRecord::Base
  
  belongs_to :event

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates :start_time, :end_time, :presence => true
  validates :capacity, :allow_nil => false, :numericality => true
  
  validate :check_allocation
  validate :check_gap
  
  after_update :waitlist_allocation
  
  
  #not to delete a batch if allocation started.
  def check_allocation
    if marked_for_destruction? and !candidates.count.zero?
      errors.add(:base, "CANNOT DELETE BATCH")
    end
  end
  
  def check_gap
    if (end_time <= start_time)
      errors.add(:base, "Keep a gap after start time: #{start_time.strftime('%H:%M')}")
    end
  end

  #move waitlisted candidates to any new or old batch with available space.
  def waitlist_allocation
    count_c = event.has_waitlist.limit(capacity - candidates.count)
    if count_c
      if candidates.count.zero? or candidates.count < capacity
        waitlist_update(count_c, self)
      end
    end
  end
    
  #updating events_candidates on batch allocation.
  def waitlist_update(candidate_data, batch)
   candidate_data.each do |element|
     element.allot_batch!
     batch.events_candidates << element
     element.save
   end
  end
  
end