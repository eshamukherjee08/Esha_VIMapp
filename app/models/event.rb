class Event < ActiveRecord::Base
  
  belongs_to :admin
  belongs_to :category
  has_many :batches, :dependent => :destroy

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  
  validates_associated :batches
  
  validates :experience, :name, :location, :category, :tech_spec, :presence => true
  validates :scheduled_at, :date => {:after => Proc.new {Time.zone.now}, :message => "Please Enter valid date"}
  
  validate :atleast_one_batch
  validate :confirm_batch_gap
  
    
  #scope to find upcoming events.  
  scope :upcoming, lambda { where("scheduled_at >= ?", Time.zone.now - DATEVALUE.day) }
  
  #scope to find past events.
  scope :past, lambda { where("scheduled_at < ?", Time.zone.now - DATEVALUE.day) }
  
  before_destroy :confirm_no_allocation
  before_save :default_value_description

   #not to create event with zero number of batches.
   def atleast_one_batch
     if new_record? and batches.empty?
      errors.add(:base, "Please ADD atleast ONE BATCH") 
     end
   end
   
   #to ensure gap between two consecutive batches.  
   def confirm_batch_gap
     batches.length.downto(2) do |index|
       if(batches[index-1].start_time < batches[index-2].end_time)
         errors.add(:base, "Please start batch #{index} after the end time of batch #{index-1}")
       end
     end
   end
   
   def confirm_no_allocation
     p "**************"
     p self
     p self.candidates
     p self.events_candidates.valid.count
     p self.events_candidates.count
     p self.allocation_started?
     p "******************"
     if(self.candidates.count > 0)
       p "*********HERE********"
       raise 'cant delete event!'
       return false
     end
   end
   
   def default_value_description
     if self.description.blank?
       self.description = 'No description available'
     end
   end
   
   def waitlist
     events_candidates.where(:state => :waitlisted)
   end


   #check if all batches of an event are full.called at candidate.rb.
   # remove event
   # rename
   def capacity_full?
     (batches.sum(:capacity) <= events_candidates.where('batch_id is not null').count)
   end
   
      
   #find the first batch that has an empty space, called at candidate.rb
   # find_empty_batch
   def find_empty_batch
     # event.batches.select{|batch| batch.capacity != batch.candidates.count)}.first
     # scope
     # batches.empty_batch
     batches.select{|batch| batch.capacity != batch.candidates.count}.first
   end
   
   def allocation_started?
     (events_candidates.valid.count > 1)
   end
   
end
