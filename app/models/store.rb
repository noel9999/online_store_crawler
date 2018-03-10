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
  PROVIDERS = {
    rt_mart: 'rt_mart', 
    wellcome: 'wellcome'
  }.freeze

  validates :name, presence: true
  validates :url, presence: true, uniqueness: true

  def crawlers_dispatch_service
    RtMartCrawlersDispatchService
  end

  def execute_crawler_service
    case name
    when PROVIDERS[:rt_mart]
      RtMartExecuteCrawlerService
    when PROVIDERS[:wellcome]
      WellcomeExecuteCrawlerService
    end
  end
end
