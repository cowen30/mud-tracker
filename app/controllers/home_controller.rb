class HomeController < ApplicationController

    skip_before_action :authorized, only: [:index, :about]

    def index
    end

end
