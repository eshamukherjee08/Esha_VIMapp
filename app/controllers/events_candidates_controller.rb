class EventsCandidatesController < ApplicationController
  
  before_filter :find_events_candidates
  
  #for marking attendance of candidates attending event.
  def mark_attended
    EventsCandidate.mark_attendance(@events_candidates)
  end
  
  
  protected
  
    def find_events_candidates
      @events_candidates = EventsCandidate.where("id IN (#{params[:events_candidates][:ids].map {|u| u.to_i}.join(",")})")
      redirect_to(root_path , :notice => 'Sorry! Data not found.') unless @events_candidates
    end
  
end