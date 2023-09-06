# Welcome To Grafana install manual

## Get VPS

To get started, you need to purchase a VPS.

> **_NOTE:_** If you are on a Linux system (for example, Debian or Ubuntu), you might need to add sudo before the command or add your user to the docker group.

Connect to server via ssh and login as a root user:

```bash
sudo -i
```

## Firewall setup

To access grafana in web browser, you need to open port 3000:

```bash
sudo ufw allow 3000
```

## Install Docker

Copy the commands below and paste them into CLI.

1. Install packages to allow apt to use a repository over HTTPS:

   ```bash
   sudo apt-get update
   sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
   ```

2. Add Docker’s official GPG key:

   ```bash
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg
   ```

   ```bash
   echo \
     "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
     "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

3. Update the apt package index:

   ```bash
   sudo apt-get update
   ```

4. Install the latest version of Docker CE and containerd:

   ```bash
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

## Start Grafana in Docker

To run the latest stable version of Grafana, run the following command:

```bash
docker run -d --restart always -p 3000:3000 --name=grafana  grafana/grafana:main-ubuntu
```

## Setup monitoring

Go to your browser and type your-ip-address:3000 in the address bar, \

```bash
login - admin \
password - admin
```

_If you want, you can set your own password after this step_ \
![grafana_main](https://ipfs.io/ipfs/QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD)

Next step: Add your first data source, select 'Prometheus'
![add_dash](https://ipfs.io/ipfs/QmfVJLCVwGv3WzR6ou9opgcFcuTYRjEqQUK6TBi7vd7HSZ)
![add datasource](https://ipfs.io/ipfs/QmZhVdd262jcFRN2CzKcgWsEUoxf9C9eN4NXN4fXsA244C)
Type in the field "URL" address of your server with Prometheus and set the Name.
![datasource_edit](https://ipfs.io/ipfs/QmU62N1LqiFEKE8v372Hg1c9pXZJbzdhavKXo7N1rMB73S) \

Then click Save & test. If everything is configured correctly, a green check mark will be displayed

![save_test](https://ipfs.io/ipfs/QmYk1yqxaexPsYQvjgUNRZrDx4ayPRSyZVreGNvGkNTQHA)

Now you will need to find out your data source uid.
It is located in your browser address bar
![find_uid](https://ipfs.io/ipfs/QmdcCM7W7AUzccmdNnAKijHgREPyDBabhaZThqShfTDeBz)

Next step: import CyberNode [dashboard](https://github.com/cybercongress/cybernode/blob/master/grafana_dashboard) to your text editor.
Then select the entire text with the ctrl + A command, turn on the search function with the ctrl + F command, find the string `<PUT_YOUR_UID>`, select it and replace it with your value from the previous step

![edit_board](https://ipfs.io/ipfs/QmSVUTpHBnwPF6VsTVddyXjnSvakGkyWx7kozyqsSTGais)
Repeat the previous step only this time search for the string `<PUT_YOUR_HOST_NAME>` and replace it with your hostname  
![pic](https://ipfs.io/ipfs/QmPkJWS3kXu1CNNsoeonSCS4TaVyF5jiC1mKj1fqsUL6z8)
After that, import your JSON file and click Load button

![upload_board](https://ipfs.io/ipfs/QmQYZeUpFmBUYNY4YPui4BEht2n3vPUTyLTaiCJYDXR6HH) \
Set the Name and click Import
![edit_board](https://ipfs.io/ipfs/Qmbycax2pAXJtJbZA7Ev8USYtpzLofu1PZvxFPt5dPWGqZ)
and you can notice how the graphs have come to life:
![board](https://ipfs.io/ipfs/QmeunC7yv1h77hVCmsevZHGdR8Xk8TwCWBLtnc1P7GB82G)

## Setting alerts

If you want to set up alerts to always be aware of your cybernode's work, then select the schedule that interests you and click the edit button:
![alert_find](https://ipfs.io/ipfs/QmRKB1y5uQjvkFtrXcoN6aXhhFza1fo9T5cU4YLnuLNGDC)

You will see the advanced settings of a specific schedule:

- Select an alert
- Edit all the fields that interest you
- Save before exiting

![alert_setup](https://ipfs.io/ipfs/QmPrncQeQ21ddvFLV3mnWXXprhrZ2fcrBZWp129YwDthX8)

You may use variable options to receive alerts, including [email](https://grafana.com/docs/grafana/latest/alerting/set-up/), [Telegram](https://community.grafana.com/t/telegram-alert-channel-configuration/242) or even calls.
