class EventsController < ApplicationController
  
  before_filter :controlaccess
  before_filter :find_event, :only => [:show, :edit, :update, :destroy]
  

  def index
    @events = Event.all :order => 'event_date'
  end

  def show
    #### COMMENT - Use where instead of find. Extract in a before_filter
    # @event = Event.where(:id => params[:id].to_i).first
    @candidates = Candidate.all
    @events_candidates = EventsCandidate.where(:event_id => params[:id].to_i).where(:cancellation=> false).all
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
    #### COMMENT - cannot assign to params
    #### COMMENT - use current_admin
    #### Can be written like this

    @event = Event.new(params[:event].merge!( { :admin_id => current_admin.id }))
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")

    #### Can be written like this
    if @event.save
      redirect_to( events_url, :notice => 'Event was successfully created.') 
    else
      render :action => "new" 
    end
  end


  def update
    @event.event_date = DateTime.strptime(params[:event][:event_date], "%m/%d/20%y") unless(params[:event][:event_date] == "")
      if @event.update_attributes(params[:event])
        redirect_to(@event, :notice => 'Event was successfully updated.')
      else
        render :action => "edit" 
      end
  end 
  
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
    end
  end
  
  def past
    @events = Event.all :order => :event_date
  end
  
  
  # def mark_attended
  #   @events_candidates = EventsCandidate.where(:event_id => params[:id].to_i).where(:cancellation => false)
  #          @events_candidates.each do |e|
  #            if params.has_key?("#{e.candidate_id}")
  #              e.update_attributes( :attended => true )
  #              e.save
  #            end 
  #          end
  #   redirect_to( events_path, :notice => 'Attendance for the event marked successfully!')
  # end
  
  protected
  
    def find_event
       @event = Event.where(:id => params[:id].to_i).first
    end
    
end
