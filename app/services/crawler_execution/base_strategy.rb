module CrawlerExecution
  class BaseStrategy
    attr_reader :url, :context
    def initialize(context)
      @context = context
      @url = context.url
    end

    def extract_data
      fail 'not implemented yet'
    end
  end
end