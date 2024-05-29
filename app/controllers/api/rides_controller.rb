# frozen_string_literal: true

module Api
  class RidesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      rides = ::Api::RidesSerializer.new(driver.rides.ordered_by_ride_score)
                                    .serializable_hash
      render json: rides
    end

    def create
      ride = driver.rides.new(ride_params)
      if ride.save
        RideService.new(ride).process
        render json: ride, status: :created
      else
        render json: ride.errors, status: :unprocessable_entity
      end
    end

    private

    def driver
      Driver.find(params[:driver_id])
    end

    def ride_params
      params.require(:ride).permit(:start_address, :destination_address)
    end

    def record_not_found
      render json: { error: 'Driver not found' }, status: :not_found
    end
  end
end
