#/bin/bash

# Run cadvisor in docker on specified port:

sudo docker run --restart always  --volume=/:/rootfs:ro   --volume=/var/run:/var/run:ro   --volume=/sys:/sys:ro   --volume=/var/lib/docker/:/var/lib/docker:ro   --volume=/dev/disk/:/dev/disk:ro   --publish=9080:8080   --detach=true   --name=cadvisor   gcr.io/google-containers/cadvisor:latest
if [ -f "/etc/prometheus/prometheus.yml" ]
then
    if ! grep -q container /etc/prometheus/prometheus.yml;
    then
    echo "  - job_name: 'container'" >> /etc/prometheus/prometheus.yml
    echo "    scrape_interval: 5s" >> /etc/prometheus/prometheus.yml
    echo "    static_configs:" >> /etc/prometheus/prometheus.yml
    echo "    - targets: ['localhost:9080']" >> /etc/prometheus/prometheus.yml
    systemctl restart prometheus
    fi
else
    printf "Cant find /etc/prometheus/prometheus.yml Do you have prometheus installed?"
fi
