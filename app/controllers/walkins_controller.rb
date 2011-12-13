class WalkinsController < ApplicationController
  def index
    # make scope - upcoming events
    @events = Event.upcoming_events #.order(:event_date)
  end
  
  
  def error
  end
  
end
