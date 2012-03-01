class WalkinsController < ApplicationController
  
  skip_before_filter :authenticate_admin

  def index
    @events = Event.upcoming.order(:scheduled_at).paginate :page => params[:page], :per_page => 3
  end
  
end
