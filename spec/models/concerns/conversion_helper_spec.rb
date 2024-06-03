require 'rails_helper'

RSpec.describe ConversionHelper, type: :helper do
  describe '#meters_to_miles' do
    it 'converts meters to miles' do
      expect(meters_to_miles(1609.34)).to be_within(0.01).of(1)
    end
  end

  describe '#seconds_to_hours' do
    it 'converts seconds to hours' do
      expect(seconds_to_hours(3600)).to eq(1)
    end
  end

  describe '#seconds_to_minutes' do
    it 'converts seconds to minutes' do
      expect(seconds_to_minutes(60)).to eq(1)
    end
  end
end
