require 'rails_helper'

describe CrawlerExecution::WellcomeStrategy do
  describe '#extract_data', :vcr do
    context 'with successfully extraction' do
      let(:context) do
        Object.new.tap do |obj|
          def obj.url
            URI('https://sbd-ec.wellcome.com.tw/product/listByCategory/26')
          end
        end
      end

      let(:strategy) { described_class.new(context) }
      it 'returns the correct data format' do
        expect(strategy.extract_data).to eq({
          "products" => [
            {
              "image_thumb_url" => "https://sbd-ec.wellcome.com.tw/fileHandler/show/3442?photoSize=480x480",
                          "url" => "https://sbd-ec.wellcome.com.tw/product/view/XaZ",
                        "title" => "鬍鬚張黃金粹魯250G/包",
                        "price" => "165"
            }, {
              "image_thumb_url" => "https://sbd-ec.wellcome.com.tw/fileHandler/show/3458?photoSize=480x480",
                          "url" => "https://sbd-ec.wellcome.com.tw/product/view/WrY",
                        "title" => "鬍鬚張黃金雞絲300G/包",
                        "price" => "165"
            }, {
              "image_thumb_url" => "https://sbd-ec.wellcome.com.tw/fileHandler/show/9099?photoSize=480x480",
                          "url" => "https://sbd-ec.wellcome.com.tw/product/view/alle",
                        "title" => "蒜味小方干200G/包",
                        "price" => "35"
            }
          ]
        })
      end
    end
  end
end