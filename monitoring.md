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
Run validator
```bash
docker run -d --gpus all --name=bostrom --restart always -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 26660:26660 -e ALLOW_SEARCH=true -v $HOME/.cyber:/root/.cyber  cyberd/cyber:bostrom-1
```
To apply config changes restart the container
```bash
docker restart bostrom
```
Then check the status of your node
```bash
docker exec bostrom cyber status
```

# Great, moving on

Now let's make sure that everything works: 
- cyber 
```bash
curl localhost:26660
```
- prometheus 
```bash
curl localhost:8090
```
- node exporter 
```bash
curl localhost:9100
```

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
![grafana](https://ipfs.io/ipfs/QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD?filename=QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD)
Next step: Add your first data source, select 'Prometheus'
![datasource](https://ipfs.io/ipfs/QmfVJLCVwGv3WzR6ou9opgcFcuTYRjEqQUK6TBi7vd7HSZ?filename=QmfVJLCVwGv3WzR6ou9opgcFcuTYRjEqQUK6TBi7vd7HSZ)
Specify in the column the URL to your server with prometheus and set the Name
![prometheus](https://ipfs.io/ipfs/QmZhVdd262jcFRN2CzKcgWsEUoxf9C9eN4NXN4fXsA244C?filename=QmZhVdd262jcFRN2CzKcgWsEUoxf9C9eN4NXN4fXsA244C)
Then click Save & test.
If everything is configured correctly, a green check mark will be displayed
![clicksave](https://ipfs.io/ipfs/QmYk1yqxaexPsYQvjgUNRZrDx4ayPRSyZVreGNvGkNTQHA)

Next step: import CyberNode dashboard and click Load button
https://github.com/cybercongress/cybernode/blob/master/monitoring/Grafana_dashboards/cyber_node.json
![loaddash](https://ipfs.io/ipfs/QmQYZeUpFmBUYNY4YPui4BEht2n3vPUTyLTaiCJYDXR6HH)
Set the Name - CyberNode and click Import 
![import](https://ipfs.io/ipfs/Qmbycax2pAXJtJbZA7Ev8USYtpzLofu1PZvxFPt5dPWGqZ)
and you can notice how the graphs have come to life:
![metrics](https://ipfs.io/ipfs/QmeunC7yv1h77hVCmsevZHGdR8Xk8TwCWBLtnc1P7GB82G)
# GOOD LUCK!
