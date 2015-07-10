class Api::V1::ProductsController < ApplicationController
  respond_to :json

  def show
    respond_with Product.find(params[:id])
  end

  def index
    respond_with products: Product.all #had to insert this artificially... not sure why..
  end

end
