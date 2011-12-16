class PasswordsController < ApplicationController
  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin

    if @admin.update_with_password(params[:admin])
      sign_in(@admin, :bypass => true)
      redirect_to events_path, :notice => "Password updated!"
    else
      render :edit, :notice => "not change"
    end
  end
  
  def index
  end
  
  
  # def new
  #      p "********************"
  #      build_admin({})
  #      render_with_scope :new
  #  end
  #    
  #    
  #    protected
  #    
  #        # The path used after sending reset password instructions
  #        def after_sending_reset_password_instructions_path_for(resource_name)
  #          new_session_path(resource_name)
  #        end
end