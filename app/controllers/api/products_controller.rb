class Api::ProductsController < ApplicationController
=begin
@api {get} /api/products Request products information
@apiName GetProductList
@apiGroup Product

@apiParam {Object} [q] query
@apiParam {String} [q.name] product's name
@apiParam {Number} [q.price_min] products'price should be greater than or equal to
@apiParam {Number} [q.price_max] products'price should be less than or equal to
@apiParam {String} [q.store_name] product of which store
@apiParam {String} [page=1] the Nth page of all products pages
@apiParam {String} [per_page=25] the number of products each page cotains

@apiSuccessExample {json} Response-Example:
{
    "items": [
        {
            "name": "[御茶園]特上奶茶550ML/瓶",
            "url": "https://sbd-ec.wellcome.com.tw/product/view/ra3",
            "image": "https://sbd-ec.wellcome.com.tw/fileHandler/show/515?photoSize=480x480",
            "price": 23,
            "tags": [
                "飲料",
                "乳品"
            ],
            "store_name": "頂好",
            "last_updated_at": "2018-03-11 18:10"
        },
        {
            "name": "[統一]麥香奶茶300ML/盒",
            "url": "https://sbd-ec.wellcome.com.tw/product/view/ADeP",
            "image": "https://sbd-ec.wellcome.com.tw/fileHandler/show/84005?photoSize=480x480",
            "price": 10,
            "tags": [
                "飲料",
                "乳品"
            ],
            "store_name": "頂好",
            "last_updated_at": "2018-03-11 18:10"
        },
        {
            "name": "[統一]飲冰室茶集綠奶茶400ML/瓶",
            "url": "https://sbd-ec.wellcome.com.tw/product/view/V4ZW",
            "image": "https://sbd-ec.wellcome.com.tw/fileHandler/show/17723?photoSize=480x480",
            "price": 23,
            "tags": [
                "冷藏乳品",
                "豆奶",
                "飲料"
            ],
            "store_name": "頂好",
            "last_updated_at": "2018-03-11 18:11"
        }
    ],
    "meta": {
        "query": {
            "name": "奶茶",
            "price_max": "23"
        },
        "current_page": 1,
        "current_per_page": 25,
        "total_pages": 1,
        "current_count": 3,
        "total_count": 3
    }
}
=end

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
