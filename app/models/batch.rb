class Batch < ActiveRecord::Base
  
  belongs_to :event

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates :start_time, :end_time, :presence => true
  validates :capacity, :allow_nil => false, :numericality => true
  
  # before_destroy :check_allocation
  #http://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html
  validate :check_allocation
  validate :check_gap
  
  scope :empty_batch, lambda {where("batch.capacity != batch.candidates.count")}
  
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
    selected_for_allocation = event.waitlist.limit(capacity - candidates.count)
    if selected_for_allocation and candidates.count < capacity
      waitlist_update(selected_for_allocation)
    end
  end
    
  #updating events_candidates on batch allocation.
  def waitlist_update(candidate_data)
   candidate_data.each do |element|
     # self needed?
     events_candidates << element
     element.allot_batch!
     element.save
   end
  end
  
end