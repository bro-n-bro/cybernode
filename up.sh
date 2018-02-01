#!/bin/bash
# show commands as they are executed
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git pull

docker network create staging_default

export COMPOSE_FILE="$DIR/elassandra/docker-compose.yml"
docker-compose pull
docker-compose up -d
sleep 10

export COMPOSE_FILE="$DIR/kafka/docker-compose.yml"
docker-compose pull
docker-compose up -d
sleep 10

export COMPOSE_FILE="$DIR/browser/docker-compose.yml"
docker-compose pull
docker-compose up -d

export COMPOSE_FILE="$DIR/chaingear/docker-compose.yml"
docker-compose pull
docker-compose up -d

export COMPOSE_FILE="$DIR/markets/docker-compose.yml"
docker-compose pull
docker-compose up -d
sleep 10

export COMPOSE_FILE="$DIR/search/docker-compose.yml"
docker-compose pull
docker-compose up -d