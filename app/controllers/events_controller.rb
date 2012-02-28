class EventsController < ApplicationController
  
  before_filter :find_event, :only => [:show, :edit, :update, :destroy, :wait_list]

  def index
    if (params[:type])
      @events = Event.past_events.order(:event_date).paginate(:per_page => 2, :page => params[:page])
    else
      @events = Event.upcoming_events.order(:event_date).paginate(:per_page => 2, :page => params[:page])
    end
  end

  def show
  end


  def new
    @event = Event.new
    3.times { @event.batches.build }
  end
  

  def change_map
    @loc = params[:location]
  end


  def edit
  end


  def create
    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    if @event.save
      redirect_to(events_path, :notice => 'Event was successfully created.') 
    else
      3.times { @event.batches.build }
      render :action => "new" 
    end
  end


  def update
    if @event.update_attributes(params[:event])
      redirect_to( events_path , :notice => 'Event was successfully updated.' )
    else
      render :action => "edit" 
    end
  end 
  
  
  def destroy
    @event.destroy
    redirect_to events_path
  end
  
  # pagination
  
  protected
  
  def find_event
     @event = Event.where(:id => params[:id]).first
     redirect_to(root_path , :notice => 'Sorry! Event not found.') unless @event
  end
    
end
