require 'rails_helper'

describe ExecuteCrawlerService do
  let(:store) { create :store, name: 'rt_mart', key: 'rt_mart' }

  describe '#initialize' do
    context 'without rt_mart store' do
      it 'raises not found error' do
        expect { described_class.new }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with rt_mart store provided' do      
      let(:service) { described_class.new args }
      context 'with invalid url' do 
        let(:args) do
          {
            tag: 'SuperTest',
            store: store,
            url: 'non-url_format'
          }
        end
        it 'raises URI::InvalidURIError' do
          expect { service }.to raise_error(URI::InvalidURIError)
        end
      end

      context 'with all args provided' do
        let(:args) do
          {
            tag: 'SuperTest',
            store: store,
            url: 'https://www.google.com.tw/'
          }
        end
        it 'returns correct instance' do
          expect(service).to be_kind_of(described_class)
        end
      end
    end
  end

  describe '#execute' do
    context 'with two products data extracted' do
      let(:data) do
        {
          products: [
            {
              title: 'Wombat sucks',
              url: 'https://github.com/felipecsl/wombat',
              image_thumb_url: 'https://en.wikipedia.org/wiki/Wombat#/media/File:Vombatus_ursinus_-Maria_Island_National_Park.jpg',
              price: '$999'
            },
            {
              title: 'mechanize rocks',
              url: 'https://github.com/sparklemotion/mechanize',
              image_thumb_url: 'https://goo.gl/images/bRfx6r',
              price: '$9999'
            }
          ]
        }
      end
      let(:args) do
        {
          tag: 'SuperTest',
          store: store,
          url: 'https://www.google.com.tw/'
        }
      end
      let(:service) { described_class.new(args) }
      before do 
        allow(service).to receive(:extract_data)
        allow(service).to receive(:products_raw_data).and_return(data)
      end

      it 'creates two products' do
        result = service.execute
        expect(result.success?).to be_truthy
        expect(Product.find_by(url: data[:products][0][:url]).price).to eq 999
        expect(Product.find_by(url: data[:products][1][:url]).price).to eq 9999      
      end

      context 'with two product already exist in our db' do
        let!(:product_a) do 
          create :product, store: store, name: data[:products][0][:title], 
            url: data[:products][0][:url], price: data[:products][0][:price][1..-1].to_i
        end
        let!(:product_b) do 
          create :product, store: store, name: data[:products][1][:title], 
            url: data[:products][1][:url], price: data[:products][1][:price][1..-1].to_i
        end

        it 'just touches those products' do
          expect { service.execute }.to change { product_a.reload.updated_at }
                                        .and change { product_b.reload.updated_at }
        end
      end
    end
  end
end