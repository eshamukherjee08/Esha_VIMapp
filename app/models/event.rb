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
    
  #scope to find upcoming events.  
  # Make 1 a conntant
  scope :upcoming_events, lambda { where("event_date >= ?", Time.zone.now - 1.day) }
  
  #scope to find past events.
  scope :past_events, lambda { where("event_date < ?", Time.zone.now - 1.day) }
  
  after_save :waitlist_allocation
  
  validate :batch_end_time
  validate :batch_start_time
   
   
   #not to delete a batch if allocation started.
   def confirm_count
     if new_record? and batches.empty?
      errors.add_to_base "Please ADD atleast ONE BATCH"
     else
       self.batches.each do |batch|
         if batch.marked_for_destruction? and !batch.candidates.count.zero?
          errors.add_to_base"CANNOT DELETE BATCH STARTING FROM : #{batch.start_time.strftime('%H:%M')} "
         end
       end  
     end
   end
   
   #move waitlisted candidates to any new or old batch with available space.
   def waitlist_allocation
     batches.each do |batch|
       if batch.candidates.count.zero? or batch.candidates.count < batch.capacity
         c = self.events_candidates.where(:waitlist => true).limit(batch.capacity)
         c.each do |ele|
           ele.update_attributes(:waitlist => false, :batch_id => batch.id)
         end
       end
     end
   end
   
   #to ensure gap between a batch's start and end time.
   def batch_end_time
     batches.each do |batch|
       if (batch.end_time <= batch.start_time)
        errors.add_to_base "Keep a gap after start time: #{batch.start_time.strftime('%H:%M')}"
       end
     end
   end
    
  #to ensure gap between two consecutive batches.  
   def batch_start_time
     i = batches.length
     while i >= 2
       if !(self.batches[i-1].start_time > self.batches[i-2].end_time)
         errors.add_to_base "Please start batch #{i} after the end time of batch #{i-1}"
       end
       i = i-1
     end
   end

end
