class WalkinController < ApplicationController
  
  def index
    @events = Event.all :order => 'event_date'
  end
  
  def new
  end

  def create
  end

  def update
  end

  def show
  end

end
