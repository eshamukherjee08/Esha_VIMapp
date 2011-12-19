class Event < ActiveRecord::Base
  belongs_to :admin
  has_many :batches, :dependent => :destroy
  accepts_nested_attributes_for :batches, :allow_destroy => true, :reject_if => lambda { |attributes| attributes['capacity'].blank? }
  
  has_many :events_candidates , :dependent => :destroy
  has_many :candidates, :through => :events_candidates
  
  validates_associated :batches
  attr_accessible :batches_attributes, :event_date, :category, :name, :description, :tech_spec, :experience, :location, :admin_id
  
  validates :event_date, :presence => true
  validates :experience, :name, :location, :description, :category, :tech_spec, :presence => true
  
  validate :confirm_count
    
  scope :upcoming_events, where("event_date >= ?", Time.now).order(:event_date)
  
  scope :past_events, where("event_date <= ?", Time.now).order(:event_date)
  
  private
   
   def confirm_count
     if self.new_record? and self.batches.empty?
      errors.add_to_base "Please ADD atleast ONE BATCH"
     else
       self.batches.each do |batch|
         if batch.marked_for_destruction? and !batch.candidates.count.zero?
          errors.add_to_base"CANNOT DELETE BATCH STARTING FROM : #{batch.start_time.strftime('%H:%m')} "
         end
       end  
     end
   end
    
end
