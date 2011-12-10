class WalkinsController < ApplicationController
  def index
    @events = Event.all :order => 'event_date'
  end
end
