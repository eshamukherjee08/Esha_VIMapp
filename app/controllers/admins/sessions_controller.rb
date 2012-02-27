class Admins::SessionsController < Devise::SessionsController
  skip_before_filter :authenticate_admin
  
  protected

  #overriding devise default root redirection after signin.
  def after_sign_in_path_for(resource)
    events_path
  end

end