class WalkinsController < ApplicationController
  def index
    # make scope - upcoming events
    @events = Event.upcoming_events
  end
  
  
  def error
  end
  
end
