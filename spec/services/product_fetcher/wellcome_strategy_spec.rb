require 'rails_helper'

describe ProductFetcher::WellcomeStrategy, :vcr do
  let(:store) { create :store, name: 'wellcome', url: 'https://sbd-ec.wellcome.com.tw' }

  let(:context) do
    Class.new do
      attr_accessor :store
    end.new.tap { |obj| obj.store = store }
  end

  let(:strategy) { described_class.new(context) }

  describe '#extract_data' do
    context 'with everything is fine' do
      it 'returns the correct data format' do
        data = strategy.extract_data
        expect(data).to be_kind_of Hash
        expect(data.values.compact.all? { |url| URI.regexp =~ url })
        expect(data.keys.compact.all? { |tag| tag.kind_of? String })
      end
    end
  end    

  describe '#fetch_product_pages' do
    # There are 3 pages in this category on 2018/3/11
    let(:url) { 'https://sbd-ec.wellcome.com.tw/product/listByCategory/113' }

    context 'with everything is fine' do
      it 'returns all page arrays about this url' do
        expect(strategy.fetch_product_pages(url)).to eq([
          'https://sbd-ec.wellcome.com.tw/product/listByCategory/113',
          'https://sbd-ec.wellcome.com.tw/product/listByCategory/113?query=&sortValue=1&offset=32&max=32&sort=viewCount&order=desc',
          'https://sbd-ec.wellcome.com.tw/product/listByCategory/113?query=&sortValue=1&offset=64&max=32&sort=viewCount&order=desc'
          ])
      end
    end
  end
end