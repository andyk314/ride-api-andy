require 'rails_helper'

RSpec.describe Rides::MetricsCalculationService do
  let(:ride) { create(:ride) }
  let(:service) { described_class.new(ride) }

  describe '#call' do
    context 'when route data is fetched successfully' do
      let(:route_data) do
        { 'distance' => 5, 'duration' => 900 }
      end
      it 'should update all the fields in the ride model' do
        allow(Routing::DirectionService).to receive(:call).and_return(route_data)
        expect { service.call }
          .to change { ride.ride_distance }
          .and change { ride.ride_earnings }
          .and change { ride.ride_duration }
          .and change { ride.commute_duration }
          .and change { ride.ride_score }.from(0.0)
      end
    end

    context 'when the distance and duration threshold is not met' do
      let(:route_data) do
        { 'distance' => 3, 'duration' => 450 }
      end

      it 'should return the ride earnings with base rate and ride score' do
        allow(Routing::DirectionService).to receive(:call).and_return(route_data)
        total_duration = (450 + 450)/3600.to_f
        expect { service.call }
        .to change  { ride.ride_earnings }.from(nil).to(12.0)
        .and change  { ride.ride_score }.from(0.0).to(12.0/total_duration)
      end
    end

    context 'when the distance threshold is met' do
      let(:ride_data) do
        { 'distance' => 10, 'duration' => 900 }
      end

      let(:commute_data) do
        { 'distance' => 0, 'duration' => 0 }
      end

      it 'should return the earnings base rate plus the distance rate and ride score' do
        allow(service).to receive(:commute_data).and_return(commute_data)
        allow(service).to receive(:ride_data).and_return(ride_data)
        ride_earnings = 12.0 + (10-5) * 1.5
        total_duration = (900.0/3600)
        expect { service.call }
          .to change  { ride.ride_earnings }.from(nil).to(ride_earnings)
          .and change  { ride.ride_score }.from(0.0).to(ride_earnings/total_duration)
      end
    end

    context 'when the duration threshold is met' do
      let(:ride_data) do
        { 'distance' => 5, 'duration' => 3300 }
      end
      let(:commute_data) do
        { 'distance' => 1, 'duration' => 300 }
      end

      it 'should return the base rate plus the duration rate and the ride score' do
        allow(service).to receive(:commute_data).and_return(commute_data)
        allow(service).to receive(:ride_data).and_return(ride_data)
        ride_earnings = 12.0 + (3300-900)/60 * 0.70
        total_duration = (3300 + 300)/3600.to_f
        expect { service.call }
          .to change  { ride.ride_earnings }.from(nil).to(ride_earnings)
          .and change  { ride.ride_score }.from(0.0).to(ride_earnings/total_duration)
      end
    end

    context 'when both duration and distance thresholds are met' do
      let(:ride_data) do
        { 'distance' => 10, 'duration' => 3300 }
      end
      let(:commute_data) do
        { 'distance' => 1, 'duration' => 300 }
      end

      it 'should return the base rate plus the distance rate' do
        allow(service).to receive(:commute_data).and_return(commute_data)
        allow(service).to receive(:ride_data).and_return(ride_data)
        ride_earnings = 12.0 + (3300-900)/60 * 0.70 + (10-5) * 1.5
        total_duration = (3300 + 300)/3600.to_f
        expect { service.call }
          .to change  { ride.ride_earnings }.from(nil).to(ride_earnings)
          .and change  { ride.ride_score }.from(0.0).to(ride_earnings/total_duration)
      end
    end
  end
end
