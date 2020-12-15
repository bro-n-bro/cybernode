#!/bin/bash

# Set memlock limit
ulimit -l 33554432

# Call original entrypoint script
exec /docker-entrypoint.sh "${@}"