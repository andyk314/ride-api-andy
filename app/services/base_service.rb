# frozen_string_literal: true

# BaseService is a parent class that all services inherit from.
# This class provides a call method that all services will use
# It instantiates the service and calls the call method on it.
class BaseService
  def self.call(...)
    new(...).call
  end
end
