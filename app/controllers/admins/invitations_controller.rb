class Admins::InvitationsController < Devise::InvitationsController
  
  protected
  
  def after_invite_path_for(resource)
    events_path
  end

end