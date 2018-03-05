#!/bin/bash
# show commands as they are executed
set -x

CYBERNODE_REPOSITORY="/cyberdata/cybernode"
export COMPOSE_FILE="$CYBERNODE_REPOSITORY/index/search-api.yml"
docker-compose down

