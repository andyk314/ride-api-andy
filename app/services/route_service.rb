# frozen_string_literal: true

####
class RouteService
  include HTTParty
  base_uri 'https://api.openrouteservice.org'
  format :json

  attr_accessor :options, :service

  def self.call(service, options)
    new(service, options).get
  end

  def initialize(service, options = {})
    @options = options.merge!(api_key: ENV.fetch('OPEN_ROUTE_SERVICE_API'))
    @service = service
  end

  def get
    response = self.class.get(service, { query: options })
    JSON.parse(response.body)
  rescue StandardError => e
    puts "Failed to get route: #{e.message}"
    {}
  end
end
