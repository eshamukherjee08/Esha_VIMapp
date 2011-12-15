class EventsController < ApplicationController
  
  before_filter :controlaccess
  before_filter :find_event, :only => [:show, :edit, :update, :destroy]
  

  def index
    @events = Event.all :order => 'event_date'
  end

  def show
    # we need to fetch only registered candidates for a particular event
    @candidates = @event.candidates
    # use relations to fetch
    # make a scope only attended 
    @events_candidates = EventsCandidate.where(:event_id => params[:id].to_i).not_cancelled_list     
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
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")

    if @event.save
      redirect_to( events_url, :notice => 'Event was successfully created.') 
    else
      render :action => "new" 
    end
  end


  def update
    # use blank?
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date].blank?)

    if @event.update_attributes(params[:event])
      redirect_to(@event, :notice => 'Event was successfully updated.')
    else
      render :action => "edit" 
    end
  end 
  
  
  def destroy
    @event.destroy
    redirect_to event_path
  end
  
  
  def past
    @events = Event.past_events
  end
  
  
  protected
  
    def find_event
       @event = Event.where(:id => params[:id].to_i).first
    end
    
end
