# frozen_string_literal: true

module Api
  class DriversController < ApplicationController
    def create
      driver = Driver.new(driver_params)

      if driver.save
        render json: driver, status: :created
      else
        render json: driver.errors, status: :unprocessable_entity
      end
    end

    def index
      render json: Driver.all
    end

    def driver_params
      params.require(:driver).permit(:home_address)
    end
  end
end