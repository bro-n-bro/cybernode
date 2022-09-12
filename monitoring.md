## Monitoring for Сyber

# Clone the repo
```bash
git clone git@github.com:cybercongress/cybernode.git 
```
# Run the script
```bash
cd cybernode/monitoring/exporters/ && sh install_exporters_cybernode.sh 
```
Do you want to install all exporters (1) or just some of them (2)?
```bash
2 
```
Select exporter you want to install
```bash
3 
```
# Fix the configs
Stop your container
```bash
docker stop <your container>
```
Remove your container
```bash
docker rm <your container>
```
Add 26660:26660 port to docker.yml ports

Fix config.toml \ 
prometheus = false → prometheus = true


Start your container
```bash
docker up -d cyber --detach
```
# Great, moving on

Now let's make sure that everything works: 
```bash
curl localhost:26660
```
- cyber 
```bash
curl localhost:8090
```
- prometheus 
```bash
curl localhost:9100
```
- node exporter 

# GRAFANA

Install:
```bash
sudo apt-get install -y adduser libfontconfig1 && \
wget [https://dl.grafana.com/oss/release/grafana_8.0.6_amd64.deb](https://dl.grafana.com/oss/release/grafana_8.0.6_amd64.deb) && \
sudo dpkg -i grafana_8.0.6_amd64.deb 
```
Run:
```bash
sudo systemctl daemon-reload && \
sudo systemctl enable grafana-server && \
sudo systemctl restart grafana-server 
```
Check:
```bash
sudo journalctl -u grafana-server -f
```
Go to your browser, localhost:3000

login - admin, password - admin 

Next step: Add your first data source, select 'Prometheus'

Specify in the column the URL to your server with prometheus and set the Name

Then click Save & test.

If everything is configured correctly, a green check mark will be displayed


Next step: import CyberNode dashboard and click Load button

https://github.com/cybercongress/cybernode/blob/master/monitoring/Grafana_dashboards/cyber_node.json

Set the Name - CyberNode and click Import 

and you can notice how the graphs have come to life:

# GOOD LUCK!
