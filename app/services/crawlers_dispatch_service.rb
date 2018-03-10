class CrawlersDispatchService
  include Concerns::ActsAsServiceObject

  def initialize(args = {})
    args = args.symbolize_keys
    @tag, @urls, @store = args.values_at(:tag, :urls, :store)
    fail ActiveRecord::RecordNotFound unless @store.kind_of? Store    
  end

  protected

  attr_reader :tag, :urls, :store

  def process
    urls = Array(self.urls)
    return nil if urls.empty?    
    urls.map do |url|
      enqueue_crawler_job(url)
    end
  end

  def enqueue_crawler_job(url)
    SendCrawlerJob.perform_later(store.id, tag, url)
  end
end