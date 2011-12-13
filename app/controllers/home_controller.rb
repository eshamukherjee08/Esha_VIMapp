class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  # Optimize 
  def find_data
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first  
    @flag = 1
    if @events_candidate.event.event_date.future? or @events_candidate.event.event_date.today?
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
    else
      @flag =0
    end
  end

end
