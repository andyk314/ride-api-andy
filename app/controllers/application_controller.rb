# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found(exception = nil)
    render json: {
      status: 'Record Not Found',
      code: 404,
      message: exception.message
    }
  end
end
