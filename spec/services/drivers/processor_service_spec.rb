require 'rails_helper'

RSpec.describe Drivers::ProcessorService, type: :service do
  describe '#call' do
    let(:driver) { create(:driver) }
    let(:service) { described_class.new(driver) }

    context 'when geocoding is successful' do
      it 'updates the driver with the geocoded coordinates [longitude, latitude]' do
        allow(Routing::AddressGeocodingService).to receive(:call).and_return([39.799372, -89.644554])

        service.call

        expect(driver.home_address_long).to eq(39.799372)
        expect(driver.home_address_lat).to eq(-89.644554)
      end
    end

    context 'when geocoding fails' do
      it 'logs an error and returns false' do
        allow(Routing::AddressGeocodingService).to receive(:call).and_return(nil)
        expect(Rails.logger).to receive(:error).with("Failed to geocode address: #{driver.home_address}")

        expect(service.call).to eq(false)
      end
    end
  end
end
