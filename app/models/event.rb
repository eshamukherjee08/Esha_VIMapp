class Event < ActiveRecord::Base
  
  belongs_to :admin
  belongs_to :category
  
  # Can be written linke this, instead of find_empty_batch
  has_many :batches, :dependent => :destroy do
    def empty_batch
      order(:start_time).select{|batch| batch.capacity != batch.candidates.count}.first
    end
  end

  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  
  validates_associated :batches
  
  validates :experience, :name, :location, :category, :tech_spec, :presence => true
  validates :scheduled_at, :date => {:after => Proc.new {Time.zone.now}, :message => "Please Enter valid date"}
  
  # before_save
  validate :atleast_one_batch
  validate :confirm_batch_gap
  
    
  #scope to find upcoming events.  
  scope :upcoming, lambda { where("scheduled_at >= ?", Time.zone.now - DATEVALUE.day) }
  
  #scope to find past events.
  scope :past, lambda { where("scheduled_at < ?", Time.zone.now - DATEVALUE.day) }
  
  before_destroy :confirm_no_allocation
  
  # Not needed - Do not display description if empty
  before_save :default_value_description

   #not to create event with zero number of batches.
   ### remove new_record?
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
     if(self.candidates.count > 0)
       raise 'cant delete event!'
       return false
     end
   end
   
   # Remove
   def default_value_description
     if self.description.blank?
       self.description = 'No description available'
     end
   end
   

   def waitlist
     events_candidates.waitlist
   end


   # check if all batches of an event are full.called at candidate.rb.
   def capacity_full?
     (batches.sum(:capacity) <= events_candidates.count('batch_id is not null'))
   end
   
      
   #find the first batch that has an empty space, called at candidate.rb
   def find_empty_batch
     batches.select{|batch| batch.capacity != batch.candidates.count}.first
   end
   
   
   def allocation_started?
     (events_candidates.valid.count > 1)
   end
   
end
