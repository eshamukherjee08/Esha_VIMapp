class EventsCandidatesController < ApplicationController
  
  #for marking attendance of candidates attending event.
  def mark_attended
    if params[:attended]
      @events_candidates = EventsCandidate.where("id IN (#{params[:attended].keys.map {|u| u.to_i}.join(",")})")
      # mark attendance
      EventsCandidate.mark_attendance(@events_candidates)
      redirect_to( @events_candidates.first.event, :notice => 'Attendance for the event marked successfully!')
    else
      # render :nothing => true
      # render ?
      # render :partial => "candidates/confirmed"
      # render :template => "/events/#{params[:event_id]}/candidates/confirmed", :notice => "Please select candidates for marking attendance!"
      redirect_to( :back , :notice => 'Please select candidates for marking attendance!')
    end
  end
  
end