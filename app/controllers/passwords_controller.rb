class PasswordsController < ApplicationController
  
  before_filter :controlaccess
  
  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin

    if @admin.update_with_password(params[:admin])
      sign_in(@admin, :bypass => true)
      redirect_to passwords_path, :notice => "Password updated!"
    else
      render :edit, :notice => "not change"
    end
  end
  
  def index
  end
end