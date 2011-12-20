class WalkinsController < ApplicationController
  def index
    # make scope - upcoming events
    @events = Event.upcoming_events.order(:event_date).paginate :page => params[:page], :per_page => 3
  end
  
  
  def error
  end
  
end
