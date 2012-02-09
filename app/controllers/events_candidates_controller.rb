class EventsCandidatesController < ApplicationController
  
  
  #for marking attendance of candidates attending event.
  def mark_attended
    if params[:attended]
      @events_candidates = EventsCandidate.where("id IN (#{params[:attended].keys.map {|u| u.to_i}.join(",")})")
      @events_candidates.first.marking_attendance(@events_candidates)
      redirect_to( @events_candidates.first.event, :notice => 'Attendance for the event marked successfully!')
    else
      redirect_to( :back , :notice => 'Please select candidates for marking attendance!')
    end
  end
  
end