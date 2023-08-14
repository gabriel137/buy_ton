#!make
include .env

build:
	docker build -t core .

up: 
	docker compose up -d core

deps_get:
	docker compose run --rm core mix deps.get
	
mix_test:
	docker compose run --rm core mix test

docker_exec:
	docker exec -it buy_ton bash

attach:
	docker attach core
