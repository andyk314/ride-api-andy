require 'rails_helper'

RSpec.describe RouteService do
  let(:options) { { text: 'Los Angeles' } }
  let(:route_service) { described_class.new('/geocode/search', options) }

  describe '#get' do
    context 'when the request is successful' do
      it 'calls the get method and return the response' do
        allow(RouteService).to receive(:get).and_return({ features: [] })
        expect(route_service.get).to eq({ features: [] })
      end
    end

    context 'when the request fails' do
      before do
        allow(RouteService).to receive(:get).and_return({ "error"=>"not found: invalid path" })
        expect(route_service.get).to eq({ "error"=>"not found: invalid path" })
      end
    end
  end
end