class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  # Optimize 
  def find_data
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first      
    unless @events_candidate.nil?
      unless @events_candidate.cancellation
        @event = @events_candidate.event
        @candidate = @events_candidate.candidate
      else
        @f = 0
      end
    else
      @f =1
    end
  end

end
