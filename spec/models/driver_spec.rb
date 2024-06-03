require 'rails_helper'

RSpec.describe Driver, type: :model do
  describe 'validations' do
    it 'validates the presence of a home address' do
      driver = build(:driver, home_address: nil)
      expect(driver).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many rides' do
      driver = create(:driver)
      expect(driver.rides).to be_empty

      ride1 = create(:ride, driver: driver)
      ride2 = create(:ride, driver: driver)
      expect(driver.rides).to contain_exactly(ride1, ride2)
    end
  end

  describe '#home_coordinates' do
    it 'returns the home coordinates in [longitude, latitude] format' do
      driver = build(:driver, home_address_long: 10.0, home_address_lat: 20.0)
      expect(driver.home_coordinates).to eq([10.0, 20.0])
    end
  end
end
