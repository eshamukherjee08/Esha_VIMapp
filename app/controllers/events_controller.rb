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
    @event = Event.where(:id => params[:id].to_i).first
  end

  # POST /events
  def create
    #### COMMENT - cannot assign to params
    #### COMMENT - use current_admin
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")
    #### Can be written like this
    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    @event = Event.new(params[:event])
    if params[:add_batch]
      #add empty batch associated with @event.
      @event.batches.build
    elsif params[:remove_batch]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
    else
      if @event.save
        flash[:notice] = "Successfully created batch."
        redirect_to @event and return
      end
    end
    render :action => "new"
      # if @event.save
      #        redirect_to(@event, :notice => 'Event was successfully created.') 
      #      else
      #        render :action => "new" 
      #      end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    params[:event][:event_date] = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")
    @event = Event.where(:id => params[:id].to_i).first
    if params[:add_batch]
      #rebuild the batch attributes that doesnt hav an id.
      unless params[:event][:batches_attributes].blank?
        for attribute in params[:event][:batches_attributes]
          @event.batches.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      #add one more empty batch attribute
      @event.batches.build
    elsif params[:remove_batch]
      #collect all marked for delete batch ids
      removed_batches = params[:event][:batches_attributes].collect{ |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically removing the batch from database
      Batch.delete(removed_batches)
      flash[:notice] = "Batch removed"
      for attribute in params[:event][:batches_attributes]
        #rebuilding batch attributes that doesnt have an id and its _destroy attribute is not 1.
        @event.batches.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      if @event.update_attributes(params[:event])
        flash[:notice] = "Successfully updated event."
        redirect_to @event and return
      end
    end
    render :action => "edit"
  end 

    # respond_to do |format|
    #       if @event.update_attributes(params[:event])
    #         format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
    #         format.xml  { head :ok }
    #       else
    #         format.html { render :action => "edit" }
    #         format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
    #       end
    #     end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.where(:id => params[:id].to_i).first
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def past
    @events = Event.all :order => 'event_date'
  end
end
