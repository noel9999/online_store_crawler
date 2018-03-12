class ProductFetchService
  include Concerns::ActsAsServiceObject
  attr_reader :options, :data, :store
  attr_accessor :strategy

  def initialize(args = {})
    @options = default_options.merge(args.symbolize_keys)
    @store = Store.find_by!(key: options.fetch(:store_key))
    @strategy = ProductFetcher.const_get("#{store.key}_strategy".camelcase).new(self)
  end

  def execute
    extract_data.each_slice(options.fetch(:slice_count)) do |slice_data|
      slice_data.each do |tag, url|
        tag_product_page_urls = options.fetch(:iterate_product_pages) ? fetch_product_pages(url) : url
        enqueue_crawlers_dispatch_job(store.id, tag, Array(tag_product_page_urls))
      end
      sleep 2
    end
  end

  protected

  def extract_data
    @data ||= strategy.extract_data
  end

  def default_options
    {
      iterate_product_pages: false,
      slice_count: 10
    }
  end

  def enqueue_crawlers_dispatch_job(*args)
    DispatchCrawlersJob.perform_later(*args)
  end

  def fetch_product_pages(url)      
    strategy.fetch_product_pages(url)
  end
end
