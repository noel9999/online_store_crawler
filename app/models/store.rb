# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Store < ApplicationRecord
  PROVIDERS = %w(rt_mart).freeze

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true

  delegate :crawlers_dispatch_service, :execute_crawler_service, to: :class  

  def self.crawlers_dispatch_service
    RtMartCrawlersDispatchService
  end

  def self.execute_crawler_service
    RtMartExecuteCrawlerService
  end
end
