# frozen_string_literal: true

# == Schema Information
#
# Table name: rides
#
#  id                       :bigint           not null, primary key
#  commute_duration         :float
#  destination_address      :text
#  destination_address_lat  :float
#  destination_address_long :float
#  ride_distance            :float
#  ride_duration            :float
#  ride_earnings            :float
#  ride_score               :float            default(0.0)
#  start_address            :text
#  start_address_lat        :float
#  start_address_long       :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  driver_id                :bigint           not null
#
# Indexes
#
#  index_rides_on_driver_id  (driver_id)
#
# Foreign Keys
#
#  fk_rails_...  (driver_id => drivers.id)
#
class Ride < ApplicationRecord
  belongs_to :driver
  scope :ordered_by_ride_score, -> { order(ride_score: :desc) }

  def start_coords
    [start_address_long, start_address_lat].join(',')
  end

  def destination_coords
    [destination_address_long, destination_address_lat].join(',')
  end
end
