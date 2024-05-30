# README

Ride Service Api that return rides data per driver in JSON.

## Dependencies
* Ruby version 3.1.2
* Rails version 7.0.4

## Database creation & initialization
```
rails db:prepare
```

## System dependencies
```
 bundle install
```

## Environment Variables
```
cp .env.sample .env
```
> Go to [openrouteservice API](https://api.openrouteservice.org) and generate an api key and add the openroute api key to the .env file

## How to run the test suite and generate Swagger Documentation

### Initialize Rswag
```
rails g rswag:install # Initialize Rswag
```

### Run the api specs and generate the documentation
```
rails rswag
```

### Run the basic suite of unit specs.
```
 bundle exec rspec spec 
```
>This will generate [RSwag](https://github.com/rswag/rswag) to create API Documentation for api endpoints using [Swagger and OpenAPI](https://swagger.io/)


## Start the application
```bash
 bin/rails server
```

##  Testing the API Endpoints
> head to [http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html)
1. Create a driver with the POST /api/drivers, ensuring a `home_address` is pass in the body
2. With the new driver `id`, create a new ride with `id` as a query parameter, and
```
{
  "start_address": "Hollywood Bowl",
  "destination_address": "Disneyland"
}
```
3. Fetch all the ride data for a driver using the `GET /api/drivers{driver_id}/rides` endpoint
4. Verify that all the ride data info are populated
