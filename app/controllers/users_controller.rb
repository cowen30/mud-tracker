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
        helpers.send_welcome_email @user
        session[:user_id] = @user.id
        redirect_to '/'
    end

    def verify
        @user = User.find(params[:user_id])
        verification_code = params[:verification_code]
        if verification_code == @user.verification_code
            @user.verification_code = nil
            @user.active = true
            @user.save
            redirect_to @user
        end
    end

    def show
    end

    private
        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
        end

end
