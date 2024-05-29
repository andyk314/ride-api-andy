class RideInfoCalculator
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

  def process
    ride_args = {
      ride_distance: ride_distance,
      ride_duration: ride_duration,
      commute_duration: commute_duration,
      ride_earnings: ride_earnings,
      ride_score: ride_score
    }
    ride.update!(ride_args)
  end

  def ride_distance
    meters_to_miles(ride_data['distance'])
  end

  def ride_duration
    seconds_to_hours(ride_data['duration'])
  end

  def commute_duration
    seconds_to_hours(commute_data['duration'])
  end

  def ride_earnings
    @ride_earnings ||= BASE_COST + distance_earnings + duration_earnings
  end

  # Calculates score based on total earnings per total miles driven
  def ride_score
    total_duration = commute_duration + ride_duration
    total_duration.zero? ? 0 : ride_earnings / total_duration
  end

  private

  def fetch_route_data(start, destination)
    response = RouteService.call('/v2/directions/driving-car', start: start, end: destination)
    response.dig('features', 0, 'properties', 'summary') || {}
  end

  # Fetches and memoizes ride data
  def ride_data
    @ride_data ||= fetch_route_data(ride.start_coords, ride.destination_coords)
  end

  # Fetches and memoizes commute data
  def commute_data
    @commute_data ||= fetch_route_data(ride.driver.home_coordinates, ride.start_coords)
  end

  # Calculates earnings based on ride duration if ride duration exceeds the threshold
  def duration_earnings
    ride_duration_minutes = seconds_to_minutes(ride_data['duration'])
    if ride_duration_minutes > DURATION_THRESHOLD
      DURATION_RATE * (ride_duration_minutes - DURATION_THRESHOLD)
    else
      0
    end
  end

  # Calculates earnings based on ride distance if ride distance exceeds the threshold
  def distance_earnings
    ride_distance > DISTANCE_THRESHOLD ? DISTANCE_RATE * (ride_distance - DISTANCE_THRESHOLD) : 0
  end
end
