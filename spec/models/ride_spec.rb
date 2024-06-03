require 'rails_helper'

RSpec.describe Ride, type: :model do
  let(:driver) { create(:driver) }
  let(:ride) { create(:ride, driver: driver) }

  describe 'validations' do
    it 'validates the presence of a start address' do
      ride = build(:ride, start_address: nil)
      expect(ride).to_not be_valid
    end

    it 'validates the presence of a destination address' do
      ride = build(:ride, destination_address: nil)
      expect(ride).to_not be_valid
    end

    it 'validates the presence of a driver_id' do
      ride = build(:ride, driver_id: nil)
      expect(ride).to_not be_valid
    end

    it 'validates the numericality of driver_id' do
      ride = build(:ride, driver_id: 'abc')
      expect(ride).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a driver' do
      ride = create(:ride, driver: driver)
      expect(ride.driver).to eq(driver)
    end
  end

  describe 'scopes' do
    describe '.ordered_by_ride_score' do
      it 'orders rides by ride_score in descending order' do
        high_score_ride = create(:ride, driver: driver, ride_score: 10)
        low_score_ride = create(:ride, driver: driver, ride_score: 5)

        rides = Ride.ordered_by_ride_score

        expect(rides.first).to eq(high_score_ride)
        expect(rides.last).to eq(low_score_ride)
      end
    end
  end

  describe '#start_coords' do
    it 'returns the start coordinates in [longitude, latitude] format' do
      ride = create(:ride, driver: driver, start_address_long: 10.0, start_address_lat: 20.0)

      expect(ride.start_coords).to eq([10.0, 20.0])
    end
  end

  describe '#destination_coords' do
    it 'returns the destination coordinates in [longitude, latitude] format' do
      ride = create(:ride, driver: driver, destination_address_long: 30.0, destination_address_lat: 40.0)

      expect(ride.destination_coords).to eq([30.0, 40.0])
    end
  end
end
