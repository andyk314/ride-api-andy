# frozen_string_literal: true

# FetchRoute Service is a service that fetches data from an external API given a service and options.
module Routing
  # Wrapper around HTTParty to fetch external data from OpenRouteService API.
  # This allows for easy changes to a map service like GoogleMaps or http client like Faraday/RestClient
  class RouteRequestService < BaseService
    include HTTParty
    base_uri 'https://api.openrouteservice.org'
    format :json
    attr_reader :service, :options, :http_method

    # Inputs:
    # - service: service endpoint to fetch data from.
    # - options: requestion options (e.g. query parameters, body_params, headers, etc.)
    # - http_method: HTTP method to use for the request (default is :get) (e.g. :get, :post)
    def initialize(service, options = {}, http_method = :get)
      @options = options
      @service = service
      @http_method = http_method
    end

    # HTTParty has a built-in response parser and error handling mechanism
    # Returns the data object if successful, otherwise logs the error and returns an empty hash
    # can check response.success? or response.message
    def call
      response = self.class.send(http_method, @service, request_options)
      response.success? ? response : log_error(response.message)
    end

    private

    # Logs the error message and returns an empty hash
    def log_error(message)
      Rails.logger.error("Failed to get route: #{message}")
      {}
    end

    # Returns the request options with the necessary headers
    def request_options
      options.merge(
        headers: {
          'Authorization' => ENV.fetch('OPEN_ROUTE_SERVICE_API').to_s,
          'Content-Type' => 'application/json'
        }
      )
    end
  end
end
