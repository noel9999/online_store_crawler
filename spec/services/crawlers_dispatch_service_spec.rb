require 'rails_helper'

describe CrawlersDispatchService do
  let(:args) do
    {
      store: create(:store, name: 'rt_mart'),
      urls: urls,
      tag: 'google'
    }
  end
  let(:urls) { %w(https://www.google.com.tw/ https://www.google.com.tw/) }

  describe '#initialize' do
    context 'without rt_mart store' do
      it 'raises not found error' do
        expect { described_class.new }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with rt_mart store' do      

      it 'returns correct instance' do
        expect(described_class.new(args)).to be_kind_of(described_class)
      end
    end
  end

  describe '#execute' do
    let(:service) { described_class.new(args) }

    context 'with two urls provided' do
      it 'enqueues two job' do
        expect { service.execute }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(2)
      end
    end

    context 'with empty urls provided' do
      let(:urls) { [] }
      it 'enqueues no job' do
        expect { service.execute }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(0)
      end
    end
  end
end