class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_admin

  protected
  
  # before_filter
  def authenticate_admin 
    unless admin_signed_in?
      redirect_to root_path, :notice => "Please log in"
    end 
  end
  
end