class EventsCandidatesController < ApplicationController
  
  def mark_attended
    # Use update_all
    @events_candidates = EventsCandidate.where("id IN (#{params[:attended].keys.map {|u| u.to_i}.join(",")})")
    unless @events_candidates.empty?
      @events_candidates.update_all :attended => true
    end
    redirect_to( events_path, :notice => 'Attendance for the event marked successfully!')
  end
end