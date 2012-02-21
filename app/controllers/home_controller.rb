class HomeController < ApplicationController
  def index
  end
  
  def search
  end
  
  # finds registered candidate's admit card details on the basis of roll number.
  # No need of event, candidate variable - preload them while finding event_candidate
  # Meaningful name
  def find_searched_candidate_data
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num].to_i).first  
    unless !@events_candidate
      if @events_candidate.event.event_date.future? or @events_candidate.event.event_date.today?
        @msg = 'You have already cancelled your candidature.' unless !@events_candidate.cancelled?
      else
        @msg = 'Sorry Event has already taken place, Register for new!'
      end
    else
      @msg = 'Sorry wrong roll number! Enter correct roll number or register for event.'
    end
  end

end
