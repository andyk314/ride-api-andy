require 'swagger_helper'

RSpec.describe 'api/drivers', type: :request do

  path '/api/drivers' do
    get('Fetches all drivers') do
      tags 'Drivers'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('Create new driver') do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :driver, in: :body, schema: {
        type: :object,
        properties: {
          home_address: { type: :string }
        },
        required: ['home_address']
      }

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
