class Admins::InvitationsController < Devise::InvitationsController
  
  def create
      self.resource = resource_class.invite!(params[resource_name], current_inviter)

      if resource.errors.empty?
        set_flash_message :notice, :send_instructions, :email => self.resource.email
        respond_with resource, :location => after_invite_path_for(resource)
      else
        respond_with_navigational(resource) { render_with_scope :new }
      end
    end
  
  protected
  
  def after_invite_path_for(resource)
    events_path
  end

end