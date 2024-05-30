require 'swagger_helper'

describe 'api/drivers', type: :request do
  path '/api/drivers' do
    get('Fetches all drivers') do
      tags 'Drivers'
      response(200, 'successful') do
        let(:sample_response) do
          [{
            "id": 11,
            "home_address": "Dodgers Stadium",
            "created_at": "2024-05-30T00:22:33.126Z",
            "updated_at": "2024-05-30T00:22:34.271Z",
            "home_address_lat": 40.614801,
            "home_address_long": -74.119523
          }]
        end
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: sample_response
            }
          }
        end
        run_test!
      end
    end

    post('Create new driver') do
      tags 'Drivers'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :driver, in: :body, schema: {
        type: :object,
        properties: {
          home_address: { type: :string }
        },
        required: ['home_address']
      }, examples: {
        'LAX' => {
          value: { home_address: '1 World Way, Los Angeles, CA 90045' }
        },
        'Dodgers Stadium' => {
          value: { home_address: 'Dodgers Stadium' }
        }
      }

      response(201, 'successful') do
        let(:sample_response) do
          {
            "id": 11,
            "home_address": "Dodgers Stadium",
            "created_at": "2024-05-30T00:22:33.126Z",
            "updated_at": "2024-05-30T00:22:34.271Z",
            "home_address_lat": 40.614801,
            "home_address_long": -74.119523
          }
        end
        let(:driver) { { home_address: 'Dodgers Stadium' } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: sample_response
            }
          }
        end
        run_test!
      end
    end
  end
end
