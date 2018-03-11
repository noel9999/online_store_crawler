require 'rails_helper'

describe CrawlerExecution::RtMartStrategy do
  describe '#extract_data', :vcr do
    context 'with successfully extraction' do
      let(:context) do
        Object.new.tap do |obj|
          def obj.url
            URI('http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4068')
          end
        end
      end

      let(:strategy) { described_class.new(context) }
      it 'returns the correct data format' do
        expect(strategy.extract_data).to eq({
          "products" => [
            {
              "image_thumb_url" => "http://www.rt-mart.com.tw/website/uploads_product/website_2/P0000200152699_2_277383.jpg",
                          "url" => "http://www.rt-mart.com.tw/direct/index.php?action=product_detail&prod_no=P0000200152699",
                        "title" => "【奶粉】三多羊奶粉800g",
                        "price" => "$595"
            }, {
              "image_thumb_url" => "http://www.rt-mart.com.tw/website/uploads_product/website_2/P0000200059386_2_95355.jpg",
                          "url" => "http://www.rt-mart.com.tw/direct/index.php?action=product_detail&prod_no=P0000200059386",
                        "title" => "貝氏羊奶粉 700g/罐",
                        "price" => "$719"
            }    
          ]
        })
      end
    end
  end
end