class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  #controls access on the basis on admin session.
  ## Meaningful name
  def authenticate_admin 
    unless admin_signed_in?
      redirect_to root_path, :notice => "Please log in"
    end 
  end
end