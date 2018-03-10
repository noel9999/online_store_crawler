module ProductFetcher
  class BaseStrategy
    attr_reader :store, :context

    def initialize(context)
      @context = context
      @mutex = Mutex.new
      @store = context.store
    end

    def extract_data
      fail 'not implemented yet'
    end

    def fetch_product_pages
      fail 'not implemented yet'
    end
  end
end