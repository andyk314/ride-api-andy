# README

Ride Service Api that return rides data per driver in JSON.

## Dependencies
* Ruby version 3.1.2
* Rails version 7.0.4

## Database creation & initialization
```bash
bin/rails db:prepare
```

## Environment Variables
```
cp .env.sample .env
```
Go to https://api.openrouteservice.org and generate an api key add the openroute api key to the .env file

## How to run the test suite and generate Swagger Documentation
```bash
 rails g rswag:install
 rails rswag 
```
http://localhost:3000/api-docs/index.html

## System dependencies
```bash
 bundle install
```

## Start the application
```bash
 bin/rails server
```
head to http://localhost:3000/api/drivers/1/rides to test the api
