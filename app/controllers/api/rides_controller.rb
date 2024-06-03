# frozen_string_literal: true

# API module is responsible for handling API requests
module Api
  # RidesController is responsible for handling ride creation and listing rides for a driver
  class RidesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # Return serialized ride data for a driver, ordered by ride score in descending order
    def index
      rides = ::Api::RidesSerializer.new(driver.rides.ordered_by_ride_score)
                                    .serializable_hash
      render json: rides
    end

    # Upon creating a ride, the ride's start and destination addresses are geocoded and metrics are calculated.
    # Explicitly geocoding the addresses allows for better control and debugging as compared to using callbacks.
    # Geocoding can be moved to a worker in the future to avoid blocking the request. Currently, if the geocoding fails
    # and/or the metrics calculation fails, the ride is still created, but the error is logged. This can also be wrapped
    # in a transaction to ensure that the ride is not created if the geocoding or metrics calculation fails.
    def create
      ride = driver.rides.new(ride_params)

      if ride.save
        Rides::ProcessorService.call(ride)
        render json: ride, status: :created
      else
        render json: ride.errors, status: :unprocessable_entity
      end
    end

    private

    def driver
      @driver ||= Driver.find(params[:driver_id])
    end

    def ride_params
      params.require(:ride).permit(:start_address, :destination_address)
    end

    def record_not_found
      render json: { error: 'Driver not found' }, status: :not_found
    end
  end
end
