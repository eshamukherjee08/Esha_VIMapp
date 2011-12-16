class Candidate < ActiveRecord::Base
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
  attr_accessible :name, :address, :current_state, :home_town, :mobile_number, :exp, :salary_exp, :resume, :email, :dob, :starred
  
  # validates :name, :address, :current_state, :home_town, :mobile_number, :exp, :salary_exp, :resume, :presence => true
  # validates :email, :presence => true, 
  #                     :length => {:minimum => 3, :maximum => 254},
  #                     :uniqueness => true,
  #                     :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  #    
  has_attached_file :resume, :styles => { :medium => "150x150>", :thumb => "100x100#" }
  
   
    def self.send_mail_after_save(candidate, event_id)
      CandidateMailer.confirm_email(candidate, event_id).deliver
    end
    
    def self.generate_token
      Digest::MD5.hexdigest("#{Time.now}")
    end
    
    def assign_to_batch(event,candidate)
      events_candidate = EventsCandidate.where(:event_id => event.id , :candidate_id => candidate.id )
      if (events_candidate.empty? or !events_candidate.first.confirmed )
        if (event.batches.sum(:capacity) == event.candidates.count )
          @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
          @events_candidate.save
        else
          flag = true
          event.batches.each do |batch|
            while(batch.capacity != batch.candidates.count && flag )
              @events_candidate = EventsCandidate.new(:event_id => event.id, :candidate_id => candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
              @events_candidate.save
              flag = false
            end
          end
        end
      else
        redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
      end
    end
end
