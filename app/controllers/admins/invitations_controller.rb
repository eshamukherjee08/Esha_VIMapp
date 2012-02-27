class Admins::InvitationsController < Devise::InvitationsController
  
  skip_before_filter :authenticate_admin
 
  def create
      self.resource = resource_class.invite!(params[resource_name], current_inviter)

      if resource.errors.empty?
        set_flash_message :notice, :send_instructions, :email => self.resource.email
        respond_with resource, :location => after_invite_path_for(resource)
      else
        respond_with_navigational(resource) { render_with_scope :new }
      end
  end
  
  def edit
      if params[:invitation_token] && self.resource = resource_class.to_adapter.find_first( :invitation_token => params[:invitation_token] )
        render_with_scope :edit
      else
        set_flash_message(:alert, :invitation_token_invalid)
        redirect_to after_sign_out_path_for(resource_name)
      end
  end
  
  
  protected
  
  #overriding devise_invitable default root redirection after sending invitation.
  def after_invite_path_for(resource)
    events_path
  end
  
end