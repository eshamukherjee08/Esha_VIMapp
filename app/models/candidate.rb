class Candidate < ActiveRecord::Base
  has_many :events_candidates , :dependent => :destroy
  has_many :events, :through => :events_candidates
  has_many :batches, :through => :events_candidates
  # validates :name, :address, :current_state, :home_town, :mobile_number, :exp, :salary_exp, :resume, :presence => true
  #  validates :email, :presence => true, 
  #                    :length => {:minimum => 3, :maximum => 254},
  #                    :uniqueness => true,
  #                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  #  
  has_attached_file :resume, :styles => { :medium => "150x150>", :thumb => "100x100#" }
  # protected
  #   def send_mail
  #     CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
  #   end
end
