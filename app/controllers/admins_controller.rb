class AdminsController < ApplicationController
  
  #to edit admin password.
  def reset
		@admin = current_admin
	end

  #to update edited password.
	def update_password
		@admin = current_admin
		if(@admin.update_attributes(params[:admin]))
		  sign_in(@admin, :bypass => true)
			redirect_to events_path, :notice => "Password updated!"
		else
			render :action => "reset"
		end
	end

end