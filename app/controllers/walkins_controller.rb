class WalkinsController < ApplicationController
  def index
    # make scope - upcoming events
    @events = Event.all :order => 'event_date'
  end
end
