json.cache! [@request_query, @products], expires_in: 10.minutes do
  json.items do
    json.array! @products do |product|
      json.name product.name
      json.url product.url
      json.image product.image
      json.price product.price
      json.tags product.tags
      json.store_name product.store_name
      json.last_updated_at product.updated_at.strftime('%Y-%m-%d %H:%M')
    end
  end

  json.meta do
    json.query @request_query
    json.current_page @products.current_page
    json.current_per_page @products.current_per_page
    json.total_pages @products.total_pages
    json.current_count @products.count
    json.total_count @products.total_count
  end
end