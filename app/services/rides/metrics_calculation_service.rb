# frozen_string_literal: true

# Rides Module to encapsulate all ride related services
module Rides
  # Service that calculates ride metrics based on a given ride
  # Data is fetched, calculated, and saved in the ride model
  # Use a ConversionHelper module to convert units
  class MetricsCalculationService < BaseService
    include ConversionHelper
    attr_reader :ride

    BASE_COST = 12.0
    DISTANCE_RATE = 1.5 # $/mile
    DISTANCE_THRESHOLD = 5.0 # miles
    DURATION_RATE = 0.70 # $/minute
    DURATION_THRESHOLD = 15.0 # minutes

    def initialize(ride)
      @ride = ride
    end

    def call
      ride_args = {
        ride_distance: ride_distance,
        ride_duration: ride_duration,
        commute_duration: commute_duration,
        ride_earnings: ride_earnings,
        ride_score: ride_score
      }
      ride.update!(ride_args)
    end

    private

    def route_data(start, destination)
      Routing::DirectionService.call(start, destination)
    end

    # Fetches Data between destination and memoizes ride data
    def ride_data
      @ride_data ||= route_data(ride.start_coords, ride.destination_coords)
    end

    # Fetches Drivers to Start Data and memoizes commute data
    def commute_data
      @commute_data ||= route_data(ride.driver.home_coordinates, ride.start_coords)
    end

    def ride_distance
      ride_data['distance']
    end

    def ride_duration
      seconds_to_hours(ride_data['duration'])
    end

    def commute_duration
      seconds_to_hours(commute_data['duration'])
    end

    # Calculates earnings based on Based Cost, ride distance earnings and duration earnings
    def ride_earnings
      @ride_earnings ||= BASE_COST + distance_earnings + duration_earnings
    end

    # Calculates score based on total earnings per total miles driven per hour
    # Score = ride_earnings / (commute_duration + ride_duration)[in hours]
    def ride_score
      total_duration = commute_duration + ride_duration
      total_duration.zero? ? 0 : ride_earnings / total_duration
    end

    # Calculates earnings based on ride duration if ride duration exceeds the threshold
    # if ride_duration_minutes > 15 minutes, .70 * (ride_duration_minutes - 15), else 0
    def duration_earnings
      ride_duration_minutes = seconds_to_minutes(ride_data['duration'])
      if ride_duration_minutes > DURATION_THRESHOLD
        DURATION_RATE * (ride_duration_minutes - DURATION_THRESHOLD)
      else
        0
      end
    end

    # Calculates earnings based on ride distance if ride distance exceeds the threshold
    # If ride_distance > 5 miles, then 1.5 $/mile * (ride_distance - 5), else 0
    def distance_earnings
      if ride_distance > DISTANCE_THRESHOLD
        DISTANCE_RATE * (ride_distance - DISTANCE_THRESHOLD)
      else
        0
      end
    end
  end
end
