class CandidatesController < ApplicationController
  # GET /candidates
  # GET /candidates.xml
  # before_save :generate_perishable_token
  #  
  #  def generate_perishable_token
  #    self.perishable_token = Digest::MD5.hexdigest("#{Time.now}-#{self.email}")
  #  end
  
  def index
    @candidates = Candidate.all
  end

  # GET /candidates/1
  # GET /candidates/1.xml
  def show
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  # GET /candidates/new
  # GET /candidates/new.xml
  def new
    @candidate = Candidate.new
    @event_id = params[:event_id]
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end

  # POST /candidates
  # POST /candidates.xml
  def create
    @candidate = Candidate.new(params[:candidate])
    @candidate.perishable_token = Digest::MD5.hexdigest("#{Time.now}")
    respond_to do |format|
      if @candidate.save
        CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
        format.html { redirect_to(thank_you_for_registration_path , :notice => 'Candidate was successfully created.') }
        format.xml  { render :xml => @candidate, :status => :created, :location => @candidate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end
  
  def confirmation
    @event = Event.find(params[:event_id])
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    @events_candidates = EventsCandidates.new(:event_id => @event.id, :candidate_id => @candidate.id, :roll_num => UUID.new.generate.hex,:confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
    @events_candidates.save!
  end
end
