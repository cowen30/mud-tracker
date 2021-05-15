class UsersController < ApplicationController

    skip_before_action :authorized, only: [:new, :create]

    def index
        @users = User.where(active: true).order(last_name: :asc)
    end

    def new
    end

    def create
        @user = User.new(user_params)
        @user.updated_by = 1
        @user.save
        session[:user_id] = @user.id
        redirect_to '/'
    end

    def show
    end

    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
        end

end
