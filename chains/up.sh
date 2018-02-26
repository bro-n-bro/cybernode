#!/bin/bash
# show commands as they are executed
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export COMPOSE_FILE="$DIR/docker-compose.yml"
docker-compose pull
docker-compose up -d

echo "... Docker clean up ..."
docker system prune -f
