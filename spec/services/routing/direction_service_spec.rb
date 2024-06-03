require 'rails_helper'

RSpec.describe Routing::DirectionService do
  describe '#call' do
    let(:service) { described_class.new([-122.4194, 37.7749], [-118.2437, 34.0522]) }

    context 'when the direction service is successful' do
      let(:api_response) do
        {
          'routes' => [
            'summary' => {
              'distance' => 25.0, # miles
              'duration' => 10000.0 # seconds
            }
          ]
        }
      end

      it 'returns an object with distance and duration' do
        allow(Routing::RouteRequestService).to receive(:call).and_return(api_response)
        expect(service.call).to eq({ 'distance' => 25.0, 'duration' => 10000.0 })
      end
    end

    context 'when the direction service fails' do
      it 'returns empty object' do
        allow(Routing::RouteRequestService).to receive(:call).and_return({})
        expect(service.call).to eq({})
      end
    end
  end
end
