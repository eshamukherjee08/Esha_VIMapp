class HomesController < ApplicationController
  skip_before_filter :authenticate_admin
  
  # make this show
  def show
    @events = Event.upcoming.order(:scheduled_at).paginate(:per_page => 2, :page => params[:page])
  end
  
  def search
  end
  
  
  # finds registered candidate's admit card details on the basis of roll number.
  ## search_by_rollnumber
  def search_by_rollnumber
    @events_candidate = EventsCandidate.where(:roll_num => params[:roll_num]).includes(:event, :candidate).first

    if @events_candidate
      if @events_candidate.can_cancel?
        @msg = 'You have already cancelled your candidature.' if @events_candidate.cancelled?
      else
        @msg = 'Sorry Event has already taken place, Register for new!'
      end
    else
      @msg = 'Sorry wrong roll number! Enter correct roll number or register for event.'
    end
  end

end
