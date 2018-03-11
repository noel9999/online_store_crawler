class DispatchCrawlersJob < ApplicationJob
  queue_as :default

  def perform(store_id, tag, urls)
    store = Store.find(store_id)
    store.crawlers_dispatch_service.new(tag: tag, urls: urls, store: store).execute
  end
end
