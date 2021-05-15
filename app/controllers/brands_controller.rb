class BrandsController < ApplicationController

    skip_before_action :authorized, only: [:index, :show]

    def index
      @brands = Brand.order(:id)
    end

end
