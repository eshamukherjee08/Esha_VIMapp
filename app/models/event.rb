class Event < ActiveRecord::Base
  
  #event model associations.
  belongs_to :admin
  belongs_to :category
  has_many :batches, :dependent => :destroy
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  
  validates_associated :batches
  
  validates :experience, :name, :location, :description, :category, :tech_spec, :presence => true
  validates :event_date, :date => {:after => Proc.new {Time.zone.now}, :message => "Please Enter valid date"}
  
  validate :confirm_count
  validate :confirm_batch_gap
  
    
  #scope to find upcoming events.  
  # upcoming
  scope :upcoming, lambda { where("event_date >= ?", Time.zone.now - DATEVALUE.day) }
  
  #scope to find past events.
  # past
  scope :past, lambda { where("event_date < ?", Time.zone.now - DATEVALUE.day) }
  
  #   after_update
  # Move to batch
     
   #not to create event with zero number of batches.
   def confirm_count
     if new_record? and batches.empty?
      errors.add(:base, "Please ADD atleast ONE BATCH") 
     end
   end
   
   def  has_waitlist
     events_candidates.where(:current_state => :waitlisted)
   end

   # def waitlist_allocation
   #   # method on event => has waitlist_candidates

   #to ensure gap between two consecutive batches.  
   ## change name 
   def confirm_batch_gap
     batches.length.downto(2) do |index|
       if(batches[index-1].start_time < batches[index-2].end_time)
         errors.add(:base, "Please start batch #{index} after the end time of batch #{index-1}")
       end
     end
   end
   
   #check if all batches of an event are full.called at candidate.rb.
   def check_capacity(event)
     (event.batches.sum(:capacity) <= event.events_candidates.where('batch_id is not null').count)
   end
   
   
   #find the first batch that has an empty space, called at candidate.rb
   def find_batch(event)
     event.batches.select{|batch| batch if (batch.capacity != batch.candidates.count)}.first
   end
   
end
