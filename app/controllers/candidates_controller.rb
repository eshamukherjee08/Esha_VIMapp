class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy, :admitcard]
  before_filter :find_event, :only => [:create, :new, :show]
  before_filter :find_events_candidate, :only => [:confirmation]
  before_filter :find_marking_events_candidate, :only => [:mark_selected, :mark_rejected]
  skip_before_filter :authenticate_admin, :only => [:new, :create, :confirmation, :admitcard, :cancel, :show] 
  layout :compute_layout
  
  
  def index
    p "****************"
    p params
    p "****************"
    @candidates = Candidate.paginate :page => params[:page], :per_page => 15
  end

  def show
  end

  def new
    @candidate = Candidate.new
    @candidate.events_candidates.build
  end

  def edit
  end

  def create
    @candidate = Candidate.find_or_create_by_email_and_mobile_number(:email => params[:candidate][:email], :mobile_number => params[:candidate][:mobile_number])

    if @candidate.save(params[:candidate])
      Candidate.send_confirmation_mail(@candidate, params[:event_id])
      redirect_to(event_candidate_path(@event, @candidate) , :notice => 'Registered Successfully.')
    else
      render :action => "new"
    end
  end

  #remove update
  def update
    if @candidate.update_attributes(params[:candidate])
      redirect_to(@candidate, :notice => 'Candidate was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @candidate.destroy
    redirect_to candidates_path
  end
  
  #On confirming mailed link, allots candidate roll number and marks candidate as confirmed.
  def confirmation
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first   #needed at confirmation view page.
    if (@events_candidate.registered?)
      @candidate.assign_to_batch(params[:event_id],@candidate,@events_candidate)
    else
      redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
    end
  end
  
  #creating admit card for confirmend candidates.
  def admitcard
    @event = @candidate.events.first
  end
  
  
  # allows candidate to cancel registration and triggers mail to admin.
  def cancel
    ## @candidate.cancel_registerations(events.where(:id => params[:event_id]).first)
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => params[:id]).first
    @events_candidate.cancel!
    redirect_to(root_path , :notice => 'Your Registration has been Cancelled successfully!')
  end
  
  # marks candidate star on admin's discrimination.
  def mark_star
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.mark_star
  end
  
  #conducts search on the basis of event category.
  def find_category
    @category = Category.where(:id => params[:category]).first
  end
  
  def download_resume
    @candidate = Candidate.where(:id => params[:id]).first
    @candidate.resume_download
  end

  # candidate.mark_selected_for(@event)
  def mark_selected
    @events_candidate.selected
  end
  
  def mark_rejected
    @events_candidate.rejected
  end
  
  #allows admin to edit status of candidate.
  def edit_status
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => params[:id]).first
    @events_candidate.status_edit
    redirect_to @events_candidate.event
  end
  
  
  protected
  
  def find_candidate
    @candidate = Candidate.where(:id => params[:id].to_i).first
    redirect_to(root_path , :notice => 'Sorry! Candidate not found.') unless @candidate
  end
  
  def find_event
    @event = Event.where(:id => params[:event_id]).first
    redirect_to(root_path , :notice => 'Sorry! Event not found.') unless @event
  end
  
  def find_events_candidate
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => @candidate.id).first
    redirect_to(root_path , :notice => 'Sorry! Data not found.') unless @events_candidate
  end
  
  def find_marking_events_candidate
    @events_candidate = EventsCandidate.where(:event_id => params[:event_ID], :candidate_id => params[:candidate_id]).first
    redirect_to(root_path , :notice => 'Sorry! Data not found.') unless @events_candidate
  end
  
  def compute_layout
   action_name == "admitcard" ? "admitcard" : "application"
  end
  
end