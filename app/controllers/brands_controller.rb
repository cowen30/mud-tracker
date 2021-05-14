class BrandsController < ApplicationController

  def index
    @brands = Brand.order(:id)
  end

end
