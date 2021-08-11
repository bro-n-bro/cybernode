#/bin/bash

# Run cadvisor in docker on specified port:

sudo docker run --restart always  --volume=/:/rootfs:ro   --volume=/var/run:/var/run:ro   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --volume=/dev/disk/:/dev/disk:ro   --publish=9080:8080   --detach=true   --name=cadvisor   gcr.io/google-containers/cadvisor:latest
