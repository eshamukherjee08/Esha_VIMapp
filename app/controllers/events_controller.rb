class EventsController < ApplicationController
  
  before_filter :find_event, :only => [:show, :edit, :update, :destroy, :wait_list]

  def index
    if params[:type]
      @events = Event.past.order(:scheduled_at).paginate(:per_page => 2, :page => params[:page])
    else
      @events = Event.upcoming.order(:scheduled_at).paginate(:per_page => 2, :page => params[:page])
    end
  end

  def show
  end


  def new
    @event = Event.new
    @event.batches.build
  end
  
  
  def create
    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    if @event.save
      redirect_to(home_path, :notice => 'Event was successfully created.') 
    else
      render :action => "new" 
    end
  end
  

  def change_map
    @loc = params[:location]
  end


  def edit
  end
  

  def update
    if @event.update_attributes(params[:event])
      redirect_to( home_path , :notice => 'Event was successfully updated.' )
    else
      render :action => "edit" 
    end
  end 
  
  
  def destroy
    begin
      @event.destroy ? (notice = "Event Successfully Deleted!"): (notice = "Event cannot be Deleted!")
    rescue Exception => e
      notice = e.message
    end    
    redirect_to( home_path, :notice => notice )
  end
  
  
  protected
  
  def find_event
     @event = Event.where(:id => params[:id]).first
     redirect_to(root_path , :notice => 'Sorry! Event not found.') unless @event
  end 
end