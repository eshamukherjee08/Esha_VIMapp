class Candidate < ActiveRecord::Base
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
 
  attr_reader :accept
 
  attr_accessible :name, :address, :current_state, :home_town, :mobile_number, :exp, :salary_exp, :resume, :email, :dob, :starred, :accept 
 
  validates :accept, :acceptance => true
 
  validates :address, :dob, :current_state, :exp, :salary_exp, :presence => true
 
  has_attached_file :resume#, :styles => { :medium => "150x150>", :thumb => "100x100#" }
 
  validates :email, :format => { :with =>  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ }, :uniqueness => true
 
  validates :mobile_number, :format => { :with => /\A[0-9]{10}\Z/}, :uniqueness => true
 
  validates :name, :home_town, :format => {:with => /\A[a-zA-Z]+\z/}
 
  validate :resume_format
    
    def resume_format
      if !self.resume_file_name.nil?
        if !['text/plain', 'application/rtf', 'application/x-pdf', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'].include?(self.resume_content_type)
          errors.add_to_base("Resume is not a valid file type")
        end
      else
       errors.add_to_base("Please Upload your resume")
      end  
    end
    
    def self.send_confirmation_mail(candidate, event_id)
      CandidateMailer.confirm_email(candidate, event_id).deliver
    end
    
    def self.generate_token
      Digest::MD5.hexdigest("#{Time.now}")
    end
    
    def assign_to_batch(event,candidate)
      events_candidate = EventsCandidate.where(:event_id => event.id , :candidate_id => candidate.id )
      if (event.batches.sum(:capacity) <= event.candidates.count )
        # self.events_candidate << EventsCandidate.create(:event_id => event.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
        @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
        @events_candidate.save
      else
        flag = true
        event.batches.each do |batch|
          while(batch.capacity != batch.candidates.count && flag )
            #self.events_candidate << EventsCandidate.create(:event_id => event.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false  )
            @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
            @events_candidate.save
            flag = false
          end
        end
      end
    end
end
