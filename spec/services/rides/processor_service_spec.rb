require 'rails_helper'

RSpec.describe Rides::ProcessorService, type: :service do
  describe '#call' do
    let(:ride) { create(:ride) }
    let(:service) { described_class.new(ride) }

    context 'when geocoding is successful' do
      it 'updates the ride with the geocoded coordinates [longitude, latitude]' do
        allow(Routing::AddressGeocodingService).to receive(:call).and_return([39.799372, -89.644554])

        service.call

        expect(ride.start_address_long).to eq(39.799372)
        expect(ride.start_address_lat).to eq(-89.644554)
        expect(ride.destination_address_long).to eq(39.799372)
        expect(ride.destination_address_lat).to eq(-89.644554)
      end

     it 'calls MetricsCalculationService' do
        allow(Routing::AddressGeocodingService).to receive(:call).and_return([39.799372, -89.644554])
        expect(Rides::MetricsCalculationService).to receive(:call).with(ride)

        service.call
      end
    end

    context 'when geocoding fails' do
      it 'logs an error and returns false' do
        allow(Routing::AddressGeocodingService).to receive(:call).and_return(nil)
        expect(Rails.logger).to receive(:error).with("Geocoding failed for ride #{ride.id}")

        expect(service.call).to eq(false)
      end
    end
  end
end
