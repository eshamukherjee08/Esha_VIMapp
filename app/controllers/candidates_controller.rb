class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy]
  #after_save :send_mail
  
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
    @event = Event.where(:id => params[:event_id]).first
    if @event.experience == @candidate.exp
      respond_to do |format|
        if @candidate.save
          CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
          format.html { redirect_to(event_candidate_path(:event_id => params[:event_id], :id => @candidate.id ) , :notice => 'Registered Successfully.') }
        else
          format.html { render :action => "new" }
        end
      end
    else
      redirect_to(walkins_index_path , :notice => 'Sorry, your experience is not as per event requirement. Please apply for appropriate event.')
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
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.destroy
  end
  
  def confirmation
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:perishable_token => params[:perishable_token]).first
    events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => @candidate.id )
    if (events_candidate.empty? or events_candidate.first.confirmed == false )
      if (@event.batches.sum(:capacity) == @event.candidates.count )
        @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
        @events_candidate.save
      else
        @event.batches.each do |batch|
          if !(batch.capacity == batch.candidates.count)
            @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
            @events_candidate.save
            break
          end
        end
      end
    else
      redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
    end
  end
  
  def admitcard
    @event = Event.where(:id => params[:event_id]).first
    @candidate = Candidate.where(:id => params[:candidate_id]).first
  end
  
  def cancel
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id]).where(:candidate_id => params[:candidate_id]).first
    if (@events_candidate.cancellation == false )
      @events_candidate.update_attributes( :cancellation => true )
      @events_candidate.save
      redirect_to(root_path , :notice => 'Your Registration has been Cancelled successfully!')
    else
      redirect_to(root_path , :notice => 'You have already cancelled your registration!')
    end
  end
  
  def mark_candidate_star
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.update_attributes(:starred => true)
    @candidate.save
  end
  
  def find_category
    @events = Event.where(:category => params[:category].to_s).all
  end
  
  def download_resume
    @candidate = Candidate.where(:id => params[:id]).first
    send_file(@candidate.resume.path , :content_type => @candidate.resume_content_type)
  end
  
  protected
    def find_candidate
      @candidate = Candidate.where(:id => params[:id].to_i).first
    end
    
    #   def send_mail
     #     CandidateMailer.confirm_email(@candidate, params[:event_id]).deliver
     #   end
    
end
