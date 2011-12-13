class EventsCandidatesController < ApplicationController
  
  def mark_attended
    # Move in model
    if params[:attended].nil?
      redirect_to( :back , :notice => 'Please select candidates for marking attendance!')
    else
      @events_candidates = EventsCandidate.where("id IN (#{params[:attended].keys.map {|u| u.to_i}.join(",")})")
      @events_candidates.first.marking_attendance(@events_candidates)
      redirect_to( @events_candidates.first.event, :notice => 'Attendance for the event marked successfully!')
    end
  end
  
end