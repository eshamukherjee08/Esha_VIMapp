class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  def find_data
    @events_candidates = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first
    @event = Event.where(:id => @events_candidates.event_id).first
    @candidate = Candidate.where(:id => @events_candidates.candidate_id).first
  end

end
