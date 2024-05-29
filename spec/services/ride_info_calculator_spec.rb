require 'rails_helper'

RSpec.describe RideInfoCalculator, type: :service do
  let(:ride) { create(:ride) }
  let(:ride_info_calculator) { RideInfoCalculator.new(ride) }

  let(:route_data) do
    { 'features' => [{ 'properties' => { 'summary' => { 'distance' => 1000, 'duration' => 900 } } }] }
  end

  describe '#process' do
    it 'should update the ride with the ride data' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect { ride_info_calculator.process }
        .to change { ride.ride_score }.from(0.0).to(12/((900 + 900)/3600.to_f))
        .and change  { ride.ride_earnings }.from(nil).to(12)
    end
  end

  describe '#ride_data' do
    it 'should return the ride data' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.send(:ride_data)).to eq({ 'distance' => 1000, 'duration' => 900 })
    end
  end

  describe '#commute_data' do
    it 'should return the commute data' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.send(:commute_data)).to eq({ 'distance' => 1000, 'duration' => 900 })
    end
  end

  describe '#ride_distance' do
    it 'should return the ride distance' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.ride_distance).to eq(1000.to_f * 0.000621)
    end
  end

  describe '#ride_duration' do
    it 'should return the ride duration' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.ride_duration).to eq(900.to_f / 3600)
    end
  end

  describe 'commute_duration' do
    it 'should return the commute duration' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.commute_duration).to eq(900.to_f / 3600)
    end
  end

  describe '#ride_earnings' do
    it 'should return the base rate if thresholds are not met' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.ride_earnings).to eq(12)
    end

    it 'should return the base rate plus the additional distance earnings' do
      allow(RouteService).to receive(:call).and_return({ 'features' => [{ 'properties' => { 'summary' => { 'distance' => 16000, 'duration' => 900 } } }] })
      expect(ride_info_calculator.ride_earnings).to eq(12 + 1.5 * (16000 * 0.000621 - 5))
    end

    it 'should return the base rate plus the additional duration earnings' do
      allow(RouteService).to receive(:call).and_return({ 'features' => [{ 'properties' => { 'summary' => { 'distance' => 1000, 'duration' => 1000 } } }] })
      expect(ride_info_calculator.ride_earnings).to eq(12 + 0.7 * (1000/60.to_f - 15))
    end
  end

  describe '#ride_score' do
    it 'should return the ride score when thresholds are not met' do
      allow(RouteService).to receive(:call).and_return(route_data)
      expect(ride_info_calculator.ride_score).to eq(12/((900 + 900)/3600.to_f))
    end

    it 'should return the ride score when both duration and distance reaches threshold' do
      allow(RouteService).to receive(:call).and_return({ 'features' => [{ 'properties' => { 'summary' => { 'distance' => 16000, 'duration' => 1000 } } }] })
      total_duration = 1000/3600.to_f + 1000/3600.to_f
      total_earnings = 12 + 1.5 * (16000 * 0.000621 - 5) + 0.7 * (1000/60.to_f - 15)
      expect(ride_info_calculator.ride_score).to eq(total_earnings/total_duration)
    end
  end
end