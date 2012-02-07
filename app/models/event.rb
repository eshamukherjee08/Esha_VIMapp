class Event < ActiveRecord::Base
  
  #event model associations.
  belongs_to :admin
  has_many :batches, :dependent => :destroy
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates_associated :batches
  
  validates :experience, :name, :location, :description, :category, :tech_spec, :presence => true
  validates :event_date, :date => {:after => Proc.new {Time.zone.now}, :message => "Please Enter valid date"}
  
  validate :confirm_count
  validate :batch_end_time
  validate :batch_start_time
  
    
  #scope to find upcoming events.  
  scope :upcoming_events, lambda { where("event_date >= ?", Time.zone.now - DATEVALUE.day) }
  
  #scope to find past events.
  scope :past_events, lambda { where("event_date < ?", Time.zone.now - DATEVALUE.day) }
  
  after_save :waitlist_allocation
     
   #not to create event with zero number of batches.
   # Divide into 2 separate methods, 2nd should be called before_destroy -> batch
   def confirm_count
     if new_record? and batches.empty?
      errors.add(:base, "Please ADD atleast ONE BATCH") 
     end
   end
   
   #move waitlisted candidates to any new or old batch with available space.
   def waitlist_allocation
     batches.each do |batch|
       if batch.candidates.count.zero? or batch.candidates.count < batch.capacity
         c = self.events_candidates.where(:waitlist => true).limit(batch.capacity - batch.candidates.count)
         # use update_all
         # create method
         waitlist_update(c, batch.id)
       end
     end
   end
   
   #updating events_candidates on batch allocation.
   def waitlist_update(candidate_data, b_id)
    candidate_data.update_all(:waitlist => false, :batch_id => b_id) 
   end
   
   #to ensure gap between a batch's start and end time.
   def batch_end_time
     batches.each do |batch|
       if (batch.end_time <= batch.start_time)
        errors.add(:base, "Keep a gap after start time: #{batch.start_time.strftime('%H:%M')}")
       end
     end
   end
    
   #to ensure gap between two consecutive batches.  
   def batch_start_time
     batches.length.downto(2).each do |index|
      unless (batches[index-1].start_time > batches[index-2].end_time)
        errors.add(:base, "Please start batch #{index} after the end time of batch #{index-1}")
      end
     end
   end
end
