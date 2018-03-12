require 'rails_helper'

RSpec.describe Api::ProductsController, type: :controller do
  let!(:product_a) { create :product, name: 'star wars cup', price: 500 }
  let!(:product_b) { create :product, name: 'star wars watch', price: 1200 }
  let!(:product_c) { create :product, name: 'Incredible star wars book series', price: 1000 }
  let!(:product_d) { create :product, price: 600 }

  describe '#index' do
    context 'when searching name star wars' do
      let(:params) do
        {
          q: {
            name: 'star wars'
          }
        }
      end

      let(:json_body) { JSON.parse(response.body) }

      it 'does not include the product that dose not match' do
        get :index, params: params, format: :json
        expect(response.status).to eq 200
        expect(json_body['items'].map { |hash| hash['name'] }).not_to include(product_d.name)
        expect(json_body['meta']['total_count']).to eq 3
      end 
    end

    context 'when searching price >= 600 and <= 1000' do
      let(:params) do
        {
          q: {
            price_min: '600',
            price_max: '1000'
          }
        }
      end

      let(:json_body) { JSON.parse(response.body) }

      it 'does not include the product that dose not match' do
        get :index, params: params, format: :json
        expect(response.status).to eq 200
        expect(json_body['items'].map { |hash| hash['name'] }).to eq [product_c.name, product_d.name]
        expect(json_body['meta']['total_count']).to eq 2
      end 
    end

    context 'when searching price >= 600 and <= 1000 as well as name contains star wars' do
      let(:params) do
        {
          q: {
            price_min: '600',
            price_max: '1000',
            name: 'star wars'
          }
        }
      end

      let(:json_body) { JSON.parse(response.body) }

      it 'does not include the product that dose not match' do
        get :index, params: params, format: :json
        expect(response.status).to eq 200
        expect(json_body['items'].map { |hash| hash['name'] }).to eq [product_c.name]
        expect(json_body['meta']['total_count']).to eq 1
      end 
    end

    context 'when no params provided' do
      let(:params) do
        {
          q: {}
        }
      end

      let(:json_body) { JSON.parse(response.body) }

      it 'retuns all products' do
        get :index, params: params, format: :json
        expect(response.status).to eq 200
        expect(json_body['meta']['total_count']).to eq 4
      end 
    end
  end
end
