require 'rails_helper'

describe ProductFetcher::RtMartStrategy, :vcr do
  let(:store) { create :store, name: 'rt_mart', url: 'http://www.rt-mart.com.tw/direct/' }

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
    # There are 4 pages in this category on 2018/3/11
    let(:url) { 'http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4090' }

    context 'with everything is fine' do
      it 'returns all page arrays about this url' do
        expect(strategy.fetch_product_pages(url)).to eq([
          'http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4090',
          'http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4090&prod_size=&p_data_num=18&usort=auto_date%2CDESC&page=2',
          'http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4090&prod_size=&p_data_num=18&usort=auto_date%2CDESC&page=3',
          'http://www.rt-mart.com.tw/direct/index.php?action=product_sort&prod_sort_uid=4090&prod_size=&p_data_num=18&usort=auto_date%2CDESC&page=4'
          ])
      end
    end
  end
end