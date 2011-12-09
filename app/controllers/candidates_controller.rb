class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy]
  
  def change_candidate_find
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end
  
  def index
    @candidates = Candidate.all
  end

  def show
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  def new
    @candidate = Candidate.new
    @event_id = params[:event_id]
  end

  def edit
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  def create
    @candidate = Candidate.new(params[:candidate])
    @candidate.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
    respond_to do |format|
      if @candidate.save
        CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
        format.html { redirect_to(thank_you_for_registration_path , :notice => 'Candidate was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @candidate = Candidate.where(:id => params[:id].to_i).first

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to(@candidate, :notice => 'Candidate was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @candidate = Candidate.where(:id => params[:id].to_i).first
    @candidate.destroy
    redirect_to(candidates_url) 
  end
  
  def confirmation
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => @candidate.id )
    if (events_candidate.empty? or events_candidate.first.confirmed != true )
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
    
end
