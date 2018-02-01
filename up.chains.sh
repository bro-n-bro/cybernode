#!/bin/bash

export COMPOSE_FILE="$DIR/search/docker-compose.chains.yml"
docker-compose pull
docker-compose up -d
