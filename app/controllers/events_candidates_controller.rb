class EventsCandidatesController < ApplicationController
  
  before_filter :find_events_candidates
  
  #for marking attendance of candidates attending event.
  def mark_attended
    EventsCandidate.mark_attendance(@events_candidates)
  end
  
  
  protected
  
    def find_events_candidates
      if params[:events_candidates].present?
        @events_candidates = EventsCandidate.where(:id => params[:events_candidates][:ids])
      else
        render :js => "$('#display').html('Please Select Candidates For Marking Attendance!');"
      end
    end
  
end