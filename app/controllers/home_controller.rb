class HomeController < ApplicationController

    skip_before_action :authorized, only: %i[index about]
    layout 'home', only: %i[index]

    def index; end

end
