class EventsController < ApplicationController
  
  before_filter :controlaccess

  # GET /events  
  def index
    @events = Event.all :order => 'event_date'

  end

  # GET /events/1
  def show
    #### COMMENT - Use where instead of find. Extract in a before_filter
    @event = Event.find(params[:id])

  end

  # GET /events/new
  def new
    @event = Event.new
    @event.batches.build
    
  end
  
  def change_map
    @loc = params[:location]
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    #### COMMENT - cannot assign to params
    #### COMMENT - use current_admin
    p params
    params[:event][:admin_id] = session["warden.user.admin.key"][1][0] 
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y")

    # params[:event][:batches_attributes].each{ |key,value|
    #      if params[:event][:batches_attributes][key][:capacity].empty?
    #        params[:event][:batches_attributes].delete(key)
    #      end
    #     }
    
    #### Can be written like this
    # @event = Event.new(params[:event]).merge!({[:event][:admin_id] = current_admin.id })
    @event = Event.new(params[:event])

      if @event.save
        redirect_to(@event, :notice => 'Event was successfully created.') 
      else
        render :action => "new" 
      end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y")
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def past
    @events = Event.all :order => 'event_date'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
end
