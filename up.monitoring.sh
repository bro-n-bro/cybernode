#!/bin/bash
# show commands as they are executed
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export COMPOSE_FILE="$DIR/monitoring/docker-compose.yml"
docker-compose stop
docker-compose up -d