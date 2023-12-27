class RegistrationsController < ApplicationController

    def new
        user = User.find_by(id: session[:user_id])
        redirect_to posts_path if user
        @user = User.new
    end

    def create
        @user = User.create(user_params)

        if @user.save 
            redirect_to new_logins_path
        else
            flash[:alert] = "Could not save user."
            render :new, status: :unprocessable_entity
        end 
    end

    private 
        def user_params()
            params.require(:user).permit(:username, :email, :password)
        end
end
