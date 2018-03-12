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
#  key         :string
#

class Store < ApplicationRecord
  PROVIDERS = {
    rt_mart: 'rt_mart', 
    wellcome: 'wellcome'
  }.freeze

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true
  validates :key, presence: true, uniqueness: true

  delegate :crawlers_dispatch_service, :execute_crawler_service, to: :class

  def self.crawlers_dispatch_service
    CrawlersDispatchService
  end

  def self.execute_crawler_service
    ExecuteCrawlerService
  end
end
