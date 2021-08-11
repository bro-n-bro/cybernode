#/bin/bash

     sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
     sudo mkdir /etc/prometheus
     sudo mkdir /var/lib/prometheus
     sudo chown prometheus:prometheus /etc/prometheus
     sudo chown prometheus:prometheus /var/lib/prometheus
     wget https://github.com/prometheus/prometheus/releases/download/v2.29.1/prometheus-2.29.1.linux-amd64.tar.gz
     tar xfz prometheus-2.29.1.linux-amd64.tar.gz
     cd prometheus-2.29.1.linux-amd64/
     sudo cp ./prometheus /usr/local/bin/
     sudo cp ./promtool /usr/local/bin/
     sudo chown prometheus:prometheus /usr/local/bin/prometheus
     sudo chown prometheus:prometheus /usr/local/bin/promtool
     sudo cp -r ./consoles /etc/prometheus
     sudo cp -r ./console_libraries /etc/prometheus
     sudo chown -R prometheus:prometheus /etc/prometheus/consoles
     sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
     cd ..
     rm -rf prometheus-2.29.1.linux-amd64
     rm prometheus-2.29.1.linux-amd64.tar.gz

     # Necessary to fill up port of prometheus in prometheus.yml, af far as cadvisor port according to install_cadvisor.sh
     sudo cp ./service_files/prometheus.yml /etc/prometheus/prometheus.yml
     sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
     sudo cp ./service_files/prometheus.service /etc/systemd/system/prometheus.service
     sudo systemctl daemon-reload
     sudo systemctl start prometheus
     sudo systemctl status prometheus
     sudo systemctl enable prometheus