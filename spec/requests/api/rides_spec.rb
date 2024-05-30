require 'swagger_helper'

describe 'api/rides', type: :request do
  let(:driver) { create(:driver) }
  path '/api/drivers/{driver_id}/rides' do
    get 'Get rides data per user' do
      tags 'Rides'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :driver_id, in: :path, type: :string, required: true, description: 'ID of the driver'

      let(:sample_response) do
        {
          "data": [
            {
              "id": "7",
              "type": "object",
              "attributes": {
                "id": 7,
                "driverId": 1,
                "startAddress": "Downtown Los Angeles",
                "destinationAddress": "Los Angeles Zoo",
                "rideDistance": 0,
                "rideDuration": 0,
                "rideEarnings": 12,
                "rideScore": 160.17797552836487,
                "commuteDuration": 0.07491666666666666,
                "driverAddress": "1320 E 7th St #200, Los Angeles, CA 90021",
                "startAddressCoords": "-118.25787,34.043974",
                "destinationAddressCoords": "-118.24041,34.03598",
                "driverAddressCoords": "-118.288399,34.14805"
              }
            }
          ]
        }
      end

      response '200', 'rides data' do
        let(:driver_id) { driver.id}
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

    post 'Create a new ride for a user' do
      tags 'Rides'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :driver_id, in: :path, type: :string, required: true, description: 'ID of the driver'
      parameter name: :ride, in: :body, schema: {
        type: :object,
        properties: {
          start_address: { type: :string },
          destination_address: { type: :string }
        },
        required: ['start_address', 'destination_address']
      }, examples: {
        'Hollywood Bowl => Disneyland' => {
          value: { start_address: 'Hollywood Bowl', destination_address: 'Disneyland' }
        }
      }

      let(:sample_response) do
      {"data": [
          {
            "id": "7",
            "type": "object",
            "attributes": {
              "id": 7,
              "driverId": 1,
              "startAddress": "Downtown Los Angeles",
              "destinationAddress": "Los Angeles Zoo",
              "rideDistance": 0,
              "rideDuration": 0,
              "rideEarnings": 12,
              "rideScore": 160.17797552836487,
              "commuteDuration": 0.07491666666666666,
              "driverAddress": "1320 E 7th St #200, Los Angeles, CA 90021",
              "startAddressCoords": "-118.25787,34.043974",
              "destinationAddressCoords": "-118.24041,34.03598",
              "driverAddressCoords": "-118.288399,34.14805"
            }
          }]}
      end

      let(:ride) { { start_address: 'Hollywood Bowl', destination_address: 'Disneyland' } }
      let(:driver_id) { driver.id }

      response(201, 'successful') do
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
