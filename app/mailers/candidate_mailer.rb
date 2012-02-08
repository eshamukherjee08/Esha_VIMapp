class CandidateMailer < ActionMailer::Base
  
  include SendGrid
  
  
  
  default :from => "hr@vinsol.com"
  
  def confirm_email(candidate, event_id)
    @candidate = candidate
    @url = "http://#{SITENAME}/confirmation/#{event_id}/#{candidate.perishable_token}"
    mail( :to => candidate.email, :subject => "Event Participation Confirmation")
  end
end
