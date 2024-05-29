# frozen_string_literal: true

# == Schema Information
#
# Table name: drivers
#
#  id                :bigint           not null, primary key
#  home_address      :text
#  home_address_lat  :float
#  home_address_long :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Driver < ApplicationRecord
  has_many :rides, dependent: :destroy
  after_save :geocode_address, if: :home_address_previously_changed?

  def geocode_address
    response = geocode(home_address)
    long, lat = response.dig('features', 0, 'geometry', 'coordinates')
    update(home_address_lat: lat, home_address_long: long) if lat && long
  end

  def home_coordinates
    [home_address_long, home_address_lat].join(',')
  end

  private

  def geocode(search)
    RouteService.call('/geocode/search', text: search)
  end
end
