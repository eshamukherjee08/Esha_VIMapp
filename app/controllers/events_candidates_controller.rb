class EventsCandidatesController < ApplicationController
  
  
  
  #for marking attendance of candidates attending event.
  def mark_attended
    # @event = Event.where(:id => params[:event_id])
    if params[:attended]
      @events_candidates = EventsCandidate.where("id IN (#{params[:attended].keys.map {|u| u.to_i}.join(",")})")
      # mark attendance
      EventsCandidate.mark_attendance(@events_candidates)
      redirect_to( @events_candidates.first.event, :notice => 'Attendance for the event marked successfully!')
    else
      # render ?
      # render :template => "events/show", :notice => 'Please select candidates for marking attendance!'
      redirect_to( :back , :notice => 'Please select candidates for marking attendance!')
    end
  end
  
end