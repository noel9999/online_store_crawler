require 'rails_helper'

describe ProductFetcher::RtMart do
  describe '#initialize' do
    context 'without rt_mart store' do
      it 'raises not found error' do
        expect { described_class.new }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with rt_mart store' do
      let!(:store) { create :store, name: 'rt_mart' }
      it 'returns correct instance' do
        expect(described_class.new).to be_kind_of described_class
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
      let!(:store) { create :store, name: 'rt_mart' }
      let(:service) { described_class.new }

      before { allow(service).to receive(:extract_data).and_return(data) }

      it 'enqueues 5 crawlers_dispatch job' do
        expect { service.execute }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(5)
      end
    end
  end
end