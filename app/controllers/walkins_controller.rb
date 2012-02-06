class WalkinsController < ApplicationController
  #Shows all upcoming events on first page.
  def index
    @events = Event.upcoming_events.order(:event_date).paginate :page => params[:page], :per_page => 3
  end
  
  
  def error
  end
  
end
