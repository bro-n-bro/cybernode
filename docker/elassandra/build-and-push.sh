#!/bin/bash
# You must be logged in

docker build -t build/elassandra .
docker tag build/elassandra cybernode/elassandra:5.5.0.19
docker push cybernode/elassandra:5.5.0.19
docker tag build/elassandra cybernode/elassandra:latest
docker push cybernode/elassandra:latest