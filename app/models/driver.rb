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
  validates :home_address, presence: true

  # OpenRouteServiceAPI expects [longitude, latitude] format for driving data
  def home_coordinates
    [home_address_long, home_address_lat]
  end
end
