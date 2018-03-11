class SendCrawlerJob < ApplicationJob
  queue_as :default

  def perform(store_id, tag, url)
    store = Store.find store_id
    store.execute_crawler_service.new(store: store, tag: tag, url: url).execute
  end
end
