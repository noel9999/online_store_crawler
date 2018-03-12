namespace :crawler do
  desc "Fetch online store products"
  task :fetch_online_store_products, [:store_key, :iterate_product_pages] => :environment do |_task, args|
    store_key = args[:store_key]
    if Store.exists? key: store_key
      iterate_product_pages = args[:iterate_product_pages].to_s == 'iterate_product_pages' ? true : false
      puts "Start to fetch products from #{store_key} at #{DateTime.current}."
      ProductFetchService.new(store_key: store_key, iterate_product_pages: iterate_product_pages).execute
      puts "ProductFetchService has been executed at #{DateTime.current}."
    else
      puts "Store key: #{store_key} is not stored in DB." 
      next
    end
  end
end
