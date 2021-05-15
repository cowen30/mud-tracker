class HomeController < ApplicationController
  def index
  end

    skip_before_action :authorized, only: [:index]

end
