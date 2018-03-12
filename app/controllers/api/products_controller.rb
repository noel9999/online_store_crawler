class Api::ProductsController < ApplicationController
  def index
    @request_query = params.fetch(:q, {}).permit(:name, :price_min, :price_max, :store_name)
    query = {
      name_cont: @request_query[:name],
      price_gteq: @request_query[:price_min],
      price_lteq: @request_query[:price_max],
      store_name_cont: @request_query[:store_name]
    }.reject { |_k, v| v.blank? }
    q = Product.ransack(query)
    @products = q.result.page(params[:page]).per(params[:per_page])
  end
end
