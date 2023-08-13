# BuyTon

## Running manually

To start the application manually:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## Running with docker 

To start the applications by docker
  
  * Run `docker compose up -d core` to run the application with docker
  
To run the tests

  * Run `docker exec -it buy_ton bash` 
  * Run `mix test`

## Running with Makefile

To start the applications by Makefile
  
  * Run `make up` to run the application with docker
  * Run `make deps_get` to install the dependencies
  
To run the tests

  * Run `make mix_test` to running the tests