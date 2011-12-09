class ApplicationController < ActionController::Base
  #before_filter :authorize
  protect_from_forgery
  protected
  def controlaccess 
    unless admin_signed_in?
      redirect_to root_path, :notice => "Please log in"
    end 
  end
  
  # def change_event_find
  #     @event = Event.where(:id => params[:id].to_i).first
  #   end
  
  # def change_candidate_find
  #     @candidate = Candidate.where(:id => params[:id].to_i).first
  #   end
  
end