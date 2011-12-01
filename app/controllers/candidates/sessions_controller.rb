class Candidates::SessionsController < Devise::SessionsController
  
  # protected
  #   
  #     def after_sign_in_path_for(resource_or_scope)
  #       root_path
  #     end
  #     
  #     def after_sign_out_path_for(resource_or_scope)
  #       root_path
  #     end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "candidates/sessions#new")
    if is_navigational_format?
      if resource.sign_in_count == 1
        set_flash_message(:notice, :signed_in_first_time)
      else
        set_flash_message(:notice, :signed_in)
      end
    end
    sign_in(resource_name, resource)
    respond_with resource, :location => redirect_location(resource_name, resource)
  end
  
end