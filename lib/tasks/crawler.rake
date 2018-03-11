namespace :crawler do
  desc "Fetch online store products"
  task :fetch_online_store_products, [:store_name, :iterate_product_pages] => :environment do |_task, args|
    store_name = args[:store_name]
    if Store.exists? name: store_name
      iterate_product_pages = args[:iterate_product_pages].to_s == 'iterate_product_pages' ? true : false
      puts "Start to fetch products from #{store_name} at #{DateTime.current}."
      ProductFetchService.new(store_name: store_name, iterate_product_pages: iterate_product_pages).execute
      puts "ProductFetchService has been executed at #{DateTime.current}."
    else
      puts "Store name: #{store_name} is not stored in DB." 
      next
    end
  end
end
