require 'rails_helper'

RSpec.describe Routing::AddressGeocodingService do
  describe '#call' do
    let(:service) { described_class.new('1600 Amphitheatre Parkway, Mountain View, CA') }

    context 'when geocoding is successful' do
      let(:api_response) do
        {
          'features' => [
            'geometry' => {
              'coordinates' => [-122.0842499, 37.4224764]
            }
          ]
        }
      end

      it 'returns the coordinates [longitude, latitude]' do
        allow(Routing::RouteRequestService).to receive(:call).and_return(api_response)
        expect(service.call).to eq([-122.0842499, 37.4224764])
      end
    end

    context 'when geocoding fails' do
      it 'returns nil' do
        allow(Routing::RouteRequestService).to receive(:call).and_return({})
        expect(service.call).to be_nil
      end
    end
  end
end