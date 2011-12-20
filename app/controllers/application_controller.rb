class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  def controlaccess 
    unless admin_signed_in?
      redirect_to root_path, :notice => "Please log in"
    end 
  end
end