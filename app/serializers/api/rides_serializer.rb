module Api
  class RidesSerializer
    include JSONAPI::Serializer
    set_key_transform :camel_lower
    set_type :object

    attributes(
      :id,
      :driver_id,
      :start_address,
      :destination_address,
      :ride_distance,
      :ride_duration,
      :ride_earnings,
      :ride_score,
      :commute_duration
    )

    attribute :driver_address do |object|
      object.driver.home_address
    end
    attribute :start_address_coords do |object|
      object.start_coords
    end
    attribute :destination_address_coords do |object|
      object.driver.home_coordinates
    end
    attribute :driver_address_coords do |object|
      object.destination_coords
    end
  end
end
