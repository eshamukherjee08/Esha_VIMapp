class CandidateMailer < ActionMailer::Base
  default :from => "hr@vinsol.com"
  
  def confirm_email(candidate, event_id)
    @candidate = candidate
    @url = "http://localhost:3000/events/#{event_id}/candidates/#{candidate.id}/confirmation/#{candidate.perishable_token}"
    mail( :to => candidate.email, :subject => "Event Participation Confirmation")
  end
end
