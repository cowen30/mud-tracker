class BrandsController < ApplicationController

  def index
    @brands = Brand.order(:id)
  end
    skip_before_action :authorized, only: [:index, :show]


end
