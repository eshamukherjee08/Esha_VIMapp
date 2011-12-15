class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  # Optimize 
  def find_data
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first      
    
    @flag = 1
    @f = 1
    if @events_candidates.nil?
      @flag = 0
    else
      if @events_candidates.cancellation
        @f = 0
      else
        @event = Event.where(:id => @events_candidates.event_id).first
        @candidate = Candidate.where(:id => @events_candidates.candidate_id).first
      end
    end
  end

end
