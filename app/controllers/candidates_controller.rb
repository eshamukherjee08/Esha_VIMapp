class CandidatesController < ApplicationController
  # GET /candidates
  before_filter :change_candidate_find, :only => [:show, :edit, :update, :destroy]
  
  def index
    @candidates = Candidate.all
  end

  # GET /candidates/1
  def show
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  # GET /candidates/new
  def new
    @candidate = Candidate.new
    @event_id = params[:event_id]
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  # POST /candidates
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

  # PUT /candidates/1
  # PUT /candidates/1.xml
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

  # DELETE /candidates/1
  # DELETE /candidates/1.xml
  def destroy
    @candidate = Candidate.where(:id => params[:id].to_i).first
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to(candidates_url) }
    end
  end
  
  def confirmation
    @event = Event.where(:event_id => params[:event_id].to_i).first
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    events_candidates = EventsCandidates.where(:event_id => params[:event_id], :candidate_id => @candidate.id )
    if (events_candidates.empty? or events_candidates.first.confirmed != true )
      @events_candidates = EventsCandidates.new(:event_id => @event.id, :candidate_id => @candidate.id, :roll_num => UUID.new.generate.hex,:confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
      @events_candidates.save!
    else
      redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
    end
   #@events_candidates = EventsCandidates.all
  end
end
