#!/bin/bash
# show commands as they are executed
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export COMPOSE_FILE="$DIR/search/ethereum.yml"

SEARCH_REPOSITORY="/cyberdata/repositories/cyber-search"

docker build -t local-build/pump-eth -f "$SEARCH_REPOSITORY/pumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker tag local-build/pump-eth local-build/pump-eth:latest
docker-compose stop pump-eth
docker-compose run pump-eth

docker build -t local-build/dump-eth -f "$SEARCH_REPOSITORY/dumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker tag local-build/dump-eth local-build/dump-eth:latest
docker-compose stop dump-eth
docker-compose run dump-eth