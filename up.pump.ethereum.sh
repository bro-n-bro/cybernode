#!/bin/bash
# show commands as they are executed
set -x

CYBERNODE_REPOSITORY="/cyberdata/cybernode"
SEARCH_REPOSITORY="/cyberdata/repositories/cyber-search"

cd "$SEARCH_REPOSITORY"
git pull
cd "$CYBERNODE_REPOSITORY"

export COMPOSE_FILE="$CYBERNODE_REPOSITORY/index/ethereum.yml"

docker-compose stop pump-eth
docker build -t local-build/pump-ethereum -f "$SEARCH_REPOSITORY/pumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker-compose up -d

docker-compose stop dump-eth
docker build -t local-build/dump-ethereum -f "$SEARCH_REPOSITORY/dumps/ethereum/Dockerfile" "$SEARCH_REPOSITORY"
docker-compose up -d