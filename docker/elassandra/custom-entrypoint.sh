#!/bin/bash

# Set memlock limit
ulimit -l 8388608

# Call original entrypoint script
exec /docker-entrypoint.sh "${@}"