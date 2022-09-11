#/bin/bash

mkdir /var/lib/node_exporter_textfile_collectors
mkdir /opt/smarts

chown node_exporter.node_exporter /var/lib/node_exporter_textfile_collectors

systemctl daemon-reload && systemctl restart node_exporter

curl -o /opt/smart_monitor.sh  https://raw.githubusercontent.com/bro-n-bro/bro_infra/main/scripts/smart_monitor.sh 2>/dev/null

chmod +x /opt/smart_monitor.sh

crontab -l > smart_cron

echo "*/10 * * * * /opt/smart_monitor.sh" >> smart_cron

crontab smart_cron

rm smart_cron