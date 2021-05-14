class UsersController < ApplicationController

    def index
        @users = User.where(active: true).order(last_name: :asc)
    end

end
