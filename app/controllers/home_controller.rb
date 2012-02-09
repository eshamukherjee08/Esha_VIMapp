class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  # finds registered candidate's admit card details on the basis of roll number.
  def find_data
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first  
    unless @events_candidate.nil?
      if @events_candidate.event.event_date.future? or @events_candidate.event.event_date.today?
        unless @events_candidate.cancellation
          @event = @events_candidate.event
          @candidate = @events_candidate.candidate
        else
          @msg = 'You have already cancelled your candidature.'
        end
      else
        @msg = 'Sorry Event has already taken place, Register for new!'
      end
    else
      @msg = 'Sorry wrong roll number! Enter correct roll number or register for event.'
    end
  end

end
