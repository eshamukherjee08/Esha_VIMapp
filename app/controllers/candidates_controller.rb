class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy]
  
  def index
    @candidates = Candidate.all
  end

  def show
    @event = Event.where(:id => params[:event_id]).first
  end

  def new
    @candidate = Candidate.new
    @event_id = params[:event_id]
  end

  def edit
  end

  def create
    @candidate = Candidate.new(params[:candidate])
    @candidate.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
    @candidate.dob = DateTime.strptime(params[:candidate][:dob], "%m/%d/20%y") unless(params[:candidate][:dob] == "")
    respond_to do |format|
      if @candidate.save
        CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
        format.html { redirect_to(event_candidate_path(:event_id => params[:event_id], :id => @candidate.id ) , :notice => 'Registered Successfully.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to(@candidate, :notice => 'Candidate was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @candidate.destroy
    redirect_to(candidates_url) 
  end
  
  def confirmation
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => @candidate.id )
    if (events_candidate.empty? or events_candidate.first.confirmed == false )
      @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => 1, :attended => false, :waitlist => false, :cancellation => false )
      @events_candidate.save
    else
      redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
    end
  end
  
  def admitcard
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:id => params[:candidate_id]).first
  end
  
  def cancel
    @events_candidate = EventsCandidate.where(:event_id => 48).where(:candidate_id => 28).first
    if !(EventsCandidate.where(:event_id => 48).where(:candidate_id => 28).empty?)
      if (@events_candidate.cancellation == false )
        @events_candidate.update_attributes( :cancellation => true )
        @events_candidate.save
        redirect_to(root_path , :notice => 'Your Registration has been Cancelled successfully!')
      else
        redirect_to(root_path , :notice => 'You have already cancelled your registration!')
      end
    else
      redirect_to(root_path , :notice => 'Sorry enter correct roll number/register for event!')
    end
  end
  
  protected
    def find_candidate
      @candidate = Candidate.where(:id => params[:id].to_i).first
    end
    
end
