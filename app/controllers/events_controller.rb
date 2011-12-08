class EventsController < ApplicationController
  
  before_filter :controlaccess

  # GET /events  
  def index
    @events = Event.all :order => 'event_date'
  end

  # GET /events/1
  def show
    #### COMMENT - Use where instead of find. Extract in a before_filter
    @event = Event.where(:id => params[:id].to_i).first
    @candidates = Candidate.all
    @events_candidates = EventsCandidates.where(:event_id => params[:id].to_i).all
  end

  # GET /events/new
  def new
    @event = Event.new
    4.times { @event.batches.build }
  end
  
  def change_map
    @loc = params[:location]
  end

  # GET /events/1/edit
  def edit
    @event = Event.where(:id => params[:id].to_i).first
  end

  # POST /events
  def create
    #### COMMENT - cannot assign to params
    #### COMMENT - use current_admin
    #### Can be written like this

    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")

    #### Can be written like this
    if @event.save
      redirect_to(@event, :notice => 'Event was successfully created.') 
    else
      render :action => "new" 
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.where(:id => params[:id]).first
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end 
  
  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.where(:id => params[:id].to_i).first
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
    end
  end
  
  def past
    @events = Event.all :order => 'event_date'
  end
  
  def candidate_data
    @candidates = Candidate.all
  end
    
end
