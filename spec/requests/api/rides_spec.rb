require 'swagger_helper'

RSpec.describe 'api/rides', type: :request, capture_examples: true do
  let(:driver) do
    create(:driver) do |driver|
      create_list(:ride, driver: driver )
    end
  end

  let(:driver_id) { driver.id.to_s}

  path '/api/drivers/{driver_id}/rides' do
    get 'Get rides data per user' do
      tags 'Rides'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :driver_id, in: :path, type: :string, required: true

      response '200', 'rides data' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              required: %i[name phone email address],
              items: {
                type: :object,
                properties: {
                  id: { type: :string, example: '1'},
                  type: { type: :string, example: 'object'},
                  attributes: { type: :object, properties: {
                    id: { type: :string, example: '1'},
                    driverId: { type: :number, example: 1},
                    startAddress: { type: :string, example: 'Downtown Los Angeles' },
                    driverAddress: { type: :string, example: "1320 E 7th St #200, Los Angeles, CA 90021" },
                    rideDistance: { type: :float, example: 19.256369 },
                    rideDuration: { type: :float, example: 0.56369 },
                    rideEarnings: { type: :float, example: 19.25 },
                    rideScore: { type: :float, example: 25.20 },
                    commuteDuration: { type: :float, example: -1.25 },
                    startAddressCoords: { type: :string, example: "-118.25787,34.043974" },
                    destinationAddressCoords: { type: :string, example: "-118.25787,34.043974" },
                    driverAddressCoords: { type: :string, example: "-118.25787,34.043974" }
                  }
                }
              }
            }
          }
          }
        let(:driver_id) { driver.id.to_s}
        run_test! do |response|
          response_data = JSON.parse(response.body)
          expect(response_data['data']).to be_present
        end
      end
    end

    post 'Create a new ride for a user' do
      tags 'Rides'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :driver_id, in: :path, type: :string, required: true

      parameter name: :driver, in: :body, schema: {
        type: :object,
        properties: {
          start_address: { type: :string },
          destination_address: { type: :string }
        },
        required: ['start_address', 'destination_address']
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
