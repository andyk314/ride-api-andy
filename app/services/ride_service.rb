class RideService
  attr_reader :ride
  def initialize(ride)
    @ride = ride
  end

  def process
    if geocode_addresses
      ride.save
      fetch_and_populate_ride_info
    end # TODO: handle error if geocode_addresses fails
  end

  private

  def geocode_addresses
    geocode_start_address
    geocode_destination_address
  end

  def geocode_start_address
    long, lat = geocode(ride.start_address)
    ride.assign_attributes(start_address_lat: lat, start_address_long: long) if lat && long
    ride
  end

  def geocode_destination_address
    long, lat = geocode(ride.destination_address)
    ride.assign_attributes(destination_address_lat: lat, destination_address_long: long) if lat && long
    ride
  end

  # returns [long, lat] from the response
  def geocode(search)
    response = RouteService.call('/geocode/search', text: search)
    response.dig('features', 0, 'geometry', 'coordinates') || []
  end

  def fetch_and_populate_ride_info
    RideInfoCalculator.new(ride).process
  rescue StandardError => e
    Rails.logger.error "Failed to fetch and populate ride info: #{e.message}"
    false
  end
end