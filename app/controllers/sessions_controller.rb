class SessionsController < ApplicationController

    skip_before_action :authorized, only: [:new, :create]

    def new
    end

    def create
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            if params[:redirect_url].nil?
                redirect_to @user
            else
                redirect_to params[:redirect_url]
            end
        else
            redirect_to new_session_path
        end
    end

    def login
    end

    def welcome
    end

    def destroy
        session.delete(:user_id)
        reset_session
        redirect_to root_url
    end

end
