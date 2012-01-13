class Admins::SessionsController < Devise::SessionsController
  
  protected

  #overriding devise default root redirection after signin.
  def after_sign_in_path_for(resource)
    events_path
  end

end