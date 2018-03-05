#!/bin/bash
# show commands as they are executed
set -x

CYBERNODE_REPOSITORY="/cyberdata/cybernode"

export COMPOSE_FILE="$CYBERNODE_REPOSITORY/index/ethereum.yml"

docker-compose stop pump-eth
docker-compose stop dump-eth
docker-compose stop address-summary-eth

docker-compose down
