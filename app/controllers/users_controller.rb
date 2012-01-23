class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :show]
	before_filter :correct_user, :only => [:edit, :update, :show]
	
	def show
		@user = User.find(params[:id])
	end
	
	def new
		@user = User.new
  end
	
  def edit
    # @user = User.find(params[:id]) Ya no es necesario. Los filtros ya nos crean el objeto @user
		
  end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Usuario creado con éxito"
			redirect_to @user
		else
			render 'new'
		end
	end
	
	def update
    # @user = User.find(params[:id]) Ya no es necesario. Los filtros ya nos crean el objeto @user
    if @user.update_attributes(params[:user])
      flash[:success] = "Cambios en el usuario realizados con éxito."
      redirect_to @user
    else
      render 'edit'
    end
  end	
	
	private

    def authenticate
      deny_access unless signed_in?
    end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
end
