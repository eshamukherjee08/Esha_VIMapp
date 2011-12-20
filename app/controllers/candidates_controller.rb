class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy, :admitcard]
  layout :compute_layout
  
  
  def index
    @candidates = Candidate.paginate :page => params[:page], :per_page => 15
  end

  def show
    @event = Event.where(:id => params[:event_id]).first
  end

  def new
    @candidate = Candidate.new
    @event = Event.where(:id => params[:event_id]).first
  end

  def edit
  end


  def create
    @candidate = Candidate.new(params[:candidate])
    @event = Event.where(:id => params[:event_id]).first

    @candidate.perishable_token = Candidate.generate_token
    if @event.experience == @candidate.exp
      if @candidate.save
        Candidate.send_confirmation_mail(@candidate, params[:event_id])
        redirect_to(event_candidate_path(:event_id => params[:event_id], :id => @candidate.id ) , :notice => 'Registered Successfully.')
      else
        render :action => "new"
      end
    else
      redirect_to(walkins_path , :notice => 'Sorry, your experience is not as per event requirement. Please apply for appropriate event.')
    end
  end


  def update
    if @candidate.update_attributes(params[:candidate])
      redirect_to(@candidate, :notice => 'Candidate was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.destroy
  end
  
  ### Optimize
  def confirmation
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    @candidate.assign_to_batch(@event,@candidate)
  end
  

  def admitcard
    @event = Event.where(:id => params[:event_id]).first
  end
  
  def compute_layout
    action_name == "admitcard" ? "admitcard" : "application"
  end
  

  def cancel
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id]).where(:candidate_id => params[:id]).first
    @events_candidate.update_attributes( :cancellation => true )
    EventsCandidate.send_mail_after_cancel(@events_candidate)
    redirect_to(root_path , :notice => 'Your Registration has been Cancelled successfully!')
  end
  
  
  def mark_candidate_star
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.update_attributes(:starred => true)
  end
  
  
  def find_category
    if params[:category] == "SELECT CATEGORY"
      redirect_to candidates_path
      # @events = Event.all
    else
      @events = Event.where(:category => params[:category].to_s)
    end
  end
  
  
  def download_resume
    @candidate = Candidate.where(:id => params[:id]).first
    send_file(@candidate.resume.path , :content_type => @candidate.resume_content_type)
  end
  
  
  def starred_list
   @candidates = Candidate.where(:starred => true)
  end
  
  
  def find_star_category
    @events = Event.where(:category => params[:category].to_s)
  end
  
  def mark_selected
   @candidate = Candidate.where(:id => params[:candidate_id]).first
   @candidate.events_candidates.first.update_attributes(:status => true)
  end
  
  def mark_rejected
   @candidate = Candidate.where(:id => params[:candidate_id]).first
   @candidate.events_candidates.first.update_attributes(:status => false)  
  end
  
  def edit_status
    @candidate = Candidate.where(:id => params[:format]).first
    @candidate.events_candidates.first.update_attributes(:status => nil)
    event = Event.where(:id => @candidate.events_candidates.first.event_id).first
    redirect_to event
  end
  
  
  protected
  
  ## if candidate - redirect somewhere
  def find_candidate
    @candidate = Candidate.where(:id => params[:id].to_i).first
    unless @candidate
      error_walkins_path
    end
  end
    
end
