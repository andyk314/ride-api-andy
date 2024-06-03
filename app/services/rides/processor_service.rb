# frozen_string_literal: true

# Geocode start and destination addresses and calculate metrics for a ride
# This service is called when a ride is created
# It geocodes the start and destination addresses of a ride
# Updates the ride with the geocoded coordinates
# and calculates the ride metrics based on the geocoded coordinates
module Rides
  class ProcessorService < BaseService
    attr_reader :ride

    def initialize(ride)
      @ride = ride
    end

    # Expect the Geocoding Service to return [longitude, latitude] or nil
    # If the geocoding fails, log the error and return false
    # If the geocoding is successful, update the ride's start and destination address longitudes and latitudes
    def call
      start_coords = Routing::AddressGeocodingService.call(ride.start_address)
      destination_coords = Routing::AddressGeocodingService.call(ride.destination_address)

      if start_coords && destination_coords
        ride.update(
          start_address_long: start_coords.first,
          start_address_lat: start_coords.last,
          destination_address_long: destination_coords.first,
          destination_address_lat: destination_coords.last,
        )
        MetricsCalculationService.call(ride)
      else
        Rails.logger.error "Geocoding failed for ride #{ride.id}"
        false
      end
    end
  end
end
