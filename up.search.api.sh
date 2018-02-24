#!/bin/bash
# show commands as they are executed
set -x

CYBERNODE_REPOSITORY="/cyberdata/cybernode"
SEARCH_REPOSITORY="/cyberdata/repositories/cyber-search"

cd "$SEARCH_REPOSITORY"
git reset --hard
git pull
cd "$CYBERNODE_REPOSITORY"

export COMPOSE_FILE="$CYBERNODE_REPOSITORY/index/search-api.yml"

docker-compose stop
docker build -t local-build/search-api -f "$SEARCH_REPOSITORY/search-api/Dockerfile" "$SEARCH_REPOSITORY"
docker-compose up -d

docker system prune | -yes