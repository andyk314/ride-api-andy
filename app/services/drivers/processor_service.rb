# frozen_string_literal: true

# Drivers Module to handle driver related services
module Drivers
  # ProcessorService is a service object that geocodes and updates the driver's home address.
  class ProcessorService < BaseService
    attr_reader :driver

    def initialize(driver)
      @driver = driver
    end

    # Expect the Geocoding Service to return [longitude, latitude] or nil
    # If the geocoding fails, log the error and return false
    # If the geocoding is successful, update the driver's home address longitude and latitude
    def call
      longitude, latitude  = Routing::AddressGeocodingService.call(driver.home_address)
      if longitude && latitude
        driver.update(
          home_address_long: longitude,
          home_address_lat: latitude
        )
      else
        Rails.logger.error("Failed to geocode address: #{driver.home_address}")
        false
      end
    end
  end
end
