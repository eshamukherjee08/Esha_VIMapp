class CandidatesController < ApplicationController

  before_filter :find_candidate, :only => [:show, :edit, :update, :destroy]
  
  def index
    @candidates = Candidate.paginate :page=>params[:page], :per_page => 30
  end

  def show
    @event = Event.where(:id => params[:event_id]).first
  end

  def new
    @candidate = Candidate.new
  end

  def edit
  end


  def create
    @candidate = Candidate.new(params[:candidate])
    @event = Event.where(:id => params[:event_id]).first
    
    # Create a method in model to generate token
    
    @candidate.perishable_token = Candidate.generate_token
    
    if @event.experience == @candidate.exp
      if @candidate.save
        Candidate.send_mail_after_save(@candidate, params[:event_id])
        # Move in model
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
    
    events_candidate = EventsCandidate.where(:event_id => params[:event_id], :candidate_id => @candidate.id )
    
    if (events_candidate.empty? or !events_candidate.first.confirmed )
      if (@event.batches.sum(:capacity) == @event.candidates.count )
        @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => true, :cancellation => false )
        @events_candidate.save
      else
        # Move batch allocation in model
        i=0, flag = true
        @event.batches.each do |batch|
          if !(batch.capacity == batch.candidates.count)
            @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
            @events_candidate.save
            break
          end
        end
        # while( i< @event.batches.length && flag)
        #          @event.batches.each do |batch|
        #            if !(batch.capacity == batch.candidates.count)
        #              @events_candidate = EventsCandidate.new(:event_id => @event.id, :candidate_id => @candidate.id, :batch_id => batch.id, :roll_num => UUID.new.generate.hex, :confirmed => true, :attended => false, :waitlist => false, :cancellation => false )
        #              @events_candidate.save
        #              flag = 1
        #            end
        #          end 
        #        end
      end
    else
      redirect_to(root_path , :notice => 'Thank You, You Have already confirmed your registration.')
    end
  end
  

  def admitcard
    @candidate = Candidate.where(:id => params[:id]).first
    @event = @candidate.event if @candidate
  end
  

  def cancel
    @events_candidate = EventsCandidate.where(:event_id => params[:event_id]).where(:candidate_id => params[:id]).first
    @events_candidate.update_attributes( :cancellation => true )
    redirect_to(root_path , :notice => 'Your Registration has been Cancelled successfully!')
  end
  
  
  def mark_candidate_star
    @candidate = Candidate.where(:id => params[:candidate_id]).first
    @candidate.update_attributes(:starred => true)
    @candidate.save
  end
  
  
  def find_category
    @events = Event.where(:category => params[:category].to_s)
  end
  
  
  def download_resume
    @candidate = Candidate.where(:id => params[:id]).first
    send_file(@candidate.resume.path , :content_type => @candidate.resume_content_type)
  end
  

  protected

  def find_candidate
    @candidate = Candidate.where(:id => params[:id].to_i).first
  end
    
end
