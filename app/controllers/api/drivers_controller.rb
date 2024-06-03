# frozen_string_literal: true

# API module is responsible for handling API requests
module Api
  # DriversController is responsible for handling driver creation and listing drivers
  class DriversController < ApplicationController
    def index
      render json: Driver.all
    end

    # Upon creating a driver, the driver's home address is geocoded.
    # Explicitly geocoding the address allows for better control and debugging as compared to using callbacks.
    # Geocoding can be moved to a worker or wrapped in a Transaction in the future to avoid blocking the request
    # if the geocoding fails.
    def create
      driver = Driver.new(driver_params)

      if driver.save
        Drivers::ProcessorService.call(driver)
        render json: driver, status: :created
      else
        render json: driver.errors, status: :unprocessable_entity
      end
    end

    private

    def driver_params
      params.require(:driver).permit(:home_address)
    end
  end
end
