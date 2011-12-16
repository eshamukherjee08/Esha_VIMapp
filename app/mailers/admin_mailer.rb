class AdminMailer < ActionMailer::Base
  default :from => "super@vinsol.com"
  
  def cancel_notification(events_candidate)
   @events_candidate = events_candidate
   mail( :to => 'hr@vinsol.com', :subject => "Candidate Cancellation Alert!")
  end 
   
end
