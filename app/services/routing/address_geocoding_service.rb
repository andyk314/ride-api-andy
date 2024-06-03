# frozen_string_literal: true

# AddressGeocodingService is a service object that builds a request to geocode an address and returns the latitude and longitude.
module Routing
  # Encapsulates the logic to geocode an address and return the latitude and longitude.
  class AddressGeocodingService < BaseService
    attr_reader :address

    SERVICE_URL = '/geocode/search'

    # Inputs:
    # - address: A string input of a POI or address (eg. Disneyland, 123 Main Street, Los Angeles, CA).
    def initialize(address)
      @address = address
    end

    # Returns:
    # - Returns an array of two elements representing longitude and latitude of the address.
    # - [-117.91674,33.81283] [longitude, latitude]
    def call
      response = RouteRequestService.call(SERVICE_URL, request_options, :get)
      response.dig('features', 0, 'geometry', 'coordinates')
    end

    private

    # The options are set to search for the address and return only one result.
    def request_options
      {
        query: {
          text: address,
          size: 1
        }
      }
    end
  end
end
