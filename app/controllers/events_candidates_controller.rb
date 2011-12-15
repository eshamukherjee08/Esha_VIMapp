class EventsCandidatesController < ApplicationController
  
  def update
    # Use update_all
    params[:attended].keys.each do |e|
      @events_candidate = EventsCandidate.where(:id => e.to_i ).first.update_attributes( :attended => true )
    end
    redirect_to( events_path, :notice => 'Attendance for the event marked successfully!')
  end
end