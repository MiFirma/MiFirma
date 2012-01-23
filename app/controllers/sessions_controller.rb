class SessionsController < ApplicationController
	def create
		user = User.authenticate(params[:session][:email],
														 params[:session][:password])
		if user.nil?
      flash.now[:error] = "Email y/o contraseña erroneos"
      render 'new'
		else
			# Sign the user in and redirect to the user's show page.
			sign_in user
      redirect_to user
		end
	end
	
	def destroy
    sign_out
    redirect_to root_path
  end
	
  def new
  end

end
