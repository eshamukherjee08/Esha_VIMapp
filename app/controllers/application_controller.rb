class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  # before_filter
  def authenticate_admin 
    unless admin_signed_in?
      redirect_to root_path, :notice => "Please log in"
    end 
  end
end