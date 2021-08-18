class ApplicationController < ActionController::Base

    before_action :authorized
    helper_method :current_user
    helper_method :logged_in?
    helper_method :admin?

    def current_user
        User.find_by(id: session[:user_id])
    end

    def logged_in?
        !current_user.nil?
    end

    def admin?
        !UserRole.find_by(user_id: session[:user_id], role_id: 1).nil?
    end

    def authorized
        redirect_to '/login' unless logged_in?
    end

end
