class EventsController < ApplicationController
  
  #before_filter :controlaccess
  before_filter :find_event, :only => [:show, :edit, :update, :destroy, :wait_list]
  

  def index
    @events = Event.upcoming_events #.order(:event_date)
  end

  def show
    @events_candidates = @event.events_candidates.not_cancelled     
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
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date],"%m/%d/20%y") unless (params[:event][:event_date].blank?)
    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    if @event.save
      redirect_to( events_path, :notice => 'Event was successfully created.') 
    else
      render :action => "new" 
    end
  end


  def update
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date],"%m/%d/20%y") unless (params[:event][:event_date].blank?)
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
  
  
  def past
    @events = Event.past_events #.order(:event_date)
  end
  
  def wait_list
    @events_candidates = @event.events_candidates.where(:waitlist => true)
    if @events_candidates.nil?
      redirect_to( events_path , :notice => 'NO WAITLISTED CANDIDATES YET!' )
    end
  end
  
  
  protected
  
  def find_event
     @event = Event.where(:id => params[:id].to_i).first
     redirect_to( error_walkins_path , :notice => 'NOT FOUND' )  unless @event
  end
    
end
