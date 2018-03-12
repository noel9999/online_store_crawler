require 'rails_helper'

describe ProductFetchService do
  describe '#initialize' do
    context 'without store_key provided' do
      it 'raises KeyError' do
        expect { described_class.new }.to raise_error(KeyError)
      end
    end

    context 'without corresponding store found' do
      it 'raises not found error' do
        expect { described_class.new(store_key: 'rt_mart') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with store name provided' do
      let!(:store) { create :store, key: 'rt_mart', name: '大潤發' }
      it 'returns correct instance' do
        expect(described_class.new(store_key: store.key)).to be_kind_of described_class
      end
    end
  end

  describe '#execute' do
    let(:data) do
      {
        'tag1' => 'https://www.google.com.tw/',
        'tag2' => 'https://www.google.com.tw/',
        'tag3' => 'https://www.google.com.tw/',
        'tag4' => 'https://www.google.com.tw/',
        'tag5' => 'https://www.google.com.tw/',
      }
    end

    context 'with 5 links fetched' do
      let!(:store) { create :store, key: 'rt_mart', name: '大潤發' }
      let(:service) { described_class.new(store_key: store.key) }

      before { allow(service).to receive(:extract_data).and_return(data) }

      it 'enqueues 5 crawlers_dispatch job' do
        expect { service.execute }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(5)
      end
    end
  end
end