require 'rails_helper'

RSpec.describe RideService, type: :service do
  let(:ride) { create(:ride) }
  let(:service) { described_class.new(ride) }

  describe '#process' do
    context 'when geocoding is successful' do
      before do
        allow(service).to receive(:geocode_addresses).and_return(true)
        allow(service).to receive(:fetch_and_populate_ride_info)
        allow(RouteService).to receive(:call).and_return(
          { 'features' => [{ 'geometry' => { 'coordinates' => [-118.25787, 34.043974] } }] })
      end

      it 'saves the ride' do
        expect(ride).to receive(:save)
        service.process
      end

      it 'fetches and populates ride info' do
        expect(service).to receive(:fetch_and_populate_ride_info)
        service.process
      end
    end

    context 'when geocoding is unsuccessful' do
      before do
        allow(service).to receive(:geocode_addresses).and_return(false)
      end

      it 'does not save the ride' do
        expect(ride).not_to receive(:save)
        service.process
      end

      it 'does not fetch and populate ride info' do
        expect(service).not_to receive(:fetch_and_populate_ride_info)
        service.process
      end
    end
  end
end