# Monitoring for Сyber

## Clone the repo
```bash
git clone git@github.com:cybercongress/cybernode.git 
```
## Run the script
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
## Fix the config
Fix config.toml 
prometheus = false → prometheus = true
![](https://ipfs.io/ipfs/Qma1YqX1v87SqWscWwhrwe9ccuzfB4YnGcPaqvnJd2Gdyj)

Stop your container
```bash
docker stop <your container>
```
Remove your container
```bash
docker rm <your container>
```
Run your container
```bash
docker run -d --gpus all --name=bostrom --restart always -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 26660:26660 -e ALLOW_SEARCH=true -v $HOME/.cyber:/root/.cyber  cyberd/cyber:bostrom-2.1
```
Then check the status of your node
```bash
docker exec bostrom cyber status
```

## Great, moving on

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

## GRAFANA
We will need another one server where our data will be sent for graphana visualization. \
1 CPU, 2 GB RAM and 20 GB will be enough

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
Go to your browser, localhost:3000 \
login - admin, password - admin 
![](https://ipfs.io/ipfs/QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD) \
(If you want you can set your own password) \
Next step: Add your first data source, select 'Prometheus'
![](https://ipfs.io/ipfs/QmfVJLCVwGv3WzR6ou9opgcFcuTYRjEqQUK6TBi7vd7HSZ)
![](https://ipfs.io/ipfs/QmZhVdd262jcFRN2CzKcgWsEUoxf9C9eN4NXN4fXsA244C)
Type in field "URL" address of your server with prometheus and set the Name.
![](https://ipfs.io/ipfs/QmU62N1LqiFEKE8v372Hg1c9pXZJbzdhavKXo7N1rMB73S) \
Then click Save & test. If everything is configured correctly, a green check mark will be displayed
![](https://ipfs.io/ipfs/QmYk1yqxaexPsYQvjgUNRZrDx4ayPRSyZVreGNvGkNTQHA)

For further work you will need to find out your uid. 
It is located in your browser address bar
![](https://ipfs.io/ipfs/QmdcCM7W7AUzccmdNnAKijHgREPyDBabhaZThqShfTDeBz)
Next step: import CyberNode dashboard to your text editor. 
https://github.com/cybercongress/cybernode/blob/master/monitoring/Grafana_dashboards/cyber_node.json \
Then select the entire text with the ctrl + A command, turn on the search function with the ctrl + F command, find the uid value, in my case it is 000000003, select it and replace it with your value from the previous step 
![](https://ipfs.io/ipfs/QmZhUTznQ7ShRPzJC4NSrbn29fVKbX6DtW5cXg61wKNyrK)
After that, import your json file and click Load button
![](https://ipfs.io/ipfs/QmQYZeUpFmBUYNY4YPui4BEht2n3vPUTyLTaiCJYDXR6HH) \
Set the Name and click Import 
![](https://ipfs.io/ipfs/Qmbycax2pAXJtJbZA7Ev8USYtpzLofu1PZvxFPt5dPWGqZ)
and you can notice how the graphs have come to life:
![](https://ipfs.io/ipfs/QmeunC7yv1h77hVCmsevZHGdR8Xk8TwCWBLtnc1P7GB82G)
## GOOD LUCK!
