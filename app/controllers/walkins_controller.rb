class WalkinsController < ApplicationController
  
  skip_before_filter :authenticate_admin

  def index
    @events = Event.upcoming.order(:event_date).paginate :page => params[:page], :per_page => 3
  end
  
end
