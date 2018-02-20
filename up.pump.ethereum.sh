#!/bin/bash
# show commands as they are executed
set -x

CYBERNODE_REPOSITORY="/cyberdata/cybernode"
SEARCH_REPOSITORY="/cyberdata/repositories/cyber-search"

cd "$SEARCH_REPOSITORY"
git pull
cd "$CYBERNODE_REPOSITORY"

export COMPOSE_FILE="$CYBERNODE_REPOSITORY/index/ethereum.yml"

docker build -t local-build/pump-eth -f "$SEARCH_REPOSITORY/pumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker tag local-build/pump-eth local-build/pump-eth:latest
docker-compose stop pump-eth
docker-compose run pump-eth

docker build -t local-build/dump-eth -f "$SEARCH_REPOSITORY/dumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker tag local-build/dump-eth local-build/dump-eth:latest
docker-compose stop dump-eth
docker-compose run dump-eth