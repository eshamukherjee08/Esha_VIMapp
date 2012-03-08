class EventsCandidatesController < ApplicationController
  
  before_filter :find_events_candidates
  
  #for marking attendance of candidates attending event.
  def mark_attended
    EventsCandidate.mark_attendance(@events_candidates)
  end
  
  
  protected
  
    def find_events_candidates
      if params[:events_candidates].nil?
        render :js => "$('#display').html('Please Select Candidates For Marking Attendance!');";
      else
        @events_candidates = EventsCandidate.where("id IN (#{params[:events_candidates][:ids].map {|u| u.to_i}.join(",")})")
      end
    end
  
end