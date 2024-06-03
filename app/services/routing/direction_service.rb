# frozen_string_literal: true

# DirectionService is a service that fetches the route data between two sets of coordinates.
# Using the :post method option because it allows me to pass in different options to the request body.
# https://openrouteservice.org/dev/#/api-docs/v2/directions/{profile}/json/post
module Routing
  # Encapsulates the options and service for fetching route data.
  # This allows for easy changes or updates to the direction service.
  class DirectionService < BaseService
    attr_reader :start_coords, :destination_coords

    SERVICE_URL = '/v2/directions/driving-car'

    # Inputs:
    # - start_coords: [longitude, latitude]
    # - destination_coords: [longitude, latitude]
    def initialize(start_coords, destination_coords)
      @start_coords = start_coords
      @destination_coords = destination_coords
    end

    # Returns:
    # - Returns { 'distance' => 1.0, 'duration' => 1.0} if success else {}
    def call
      response = RouteRequestService.call(SERVICE_URL, options, :post)
      response.dig('routes', 0, 'summary') || {}
    end

    private

    # The options are set to get the distance in miles and remove unnecessary data.
    def options
      {
        body: {
          coordinates: [@start_coords, @destination_coords],
          geometry: false,
          instructions: false,
          units: 'mi'
        }.to_json
      }
    end
  end
end
