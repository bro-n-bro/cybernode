#/bin/bash

wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.9.0/nginx-prometheus-exporter_0.9.0_linux_arm64.tar.gz --inet4-only
tar -xzf nginx-prometheus-exporter_0.9.0_linux_arm64.tar.gz
mv nginx-prometheus-exporter /usr/local/bin/
rm nginx-prometheus-exporter_0.9.0_linux_arm64.tar.gz 
sudo cp ./service_files/nginx_prometheus_exporter.service /etc/systemd/system/nginx_prometheus_exporter.service
sudo systemctl daemon-reload
sudo systemctl start nginx_prometheus_exporter
sudo systemctl enable nginx_prometheus_exporter