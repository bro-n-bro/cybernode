# Welcome To Cybernode

## What is it for

Сybernode is designed to help Сyber decentralize and help its Heroes become Content Providers.
After completing the installation, you will end up with the following endpoints served from your server:

- `rpc.bostrom.<yourdomain.ai>` - for bostrom RPC endpoint
- `lcd.bostrom.<yourdomain.ai>` - for bostrom LCD endpoint
- `grpc.bostrom.<yourdomain.ai>` - for bostrom GRPC endpoint
- `ipfs.<yourdomain.ai>` - - for ipfs gateway endpoint

All of them could be later added to the skill registry to be used as chain data provider in `cyb.ai`:

## Requirements

```bash
Network: Static ip address, domain name directed to this IP
CPU: 6 cores
RAM: 32 GB
SSD: 4+ TB NVME SSD
Connection: 30+Mbps, Stable and low-latency connection
GPU: Nvidia GeForce (or Tesla/Titan/Quadro) with CUDA-cores; 4+ Gb of video memory*
Software: Ubuntu 20.04 LTS / 22.04 LTS
Optional: VPS for Grafana monitoring server (standard config for Cybernode includes automatic installation)
```

## Cybernode setup

*To avoid possible misconfiguration issues and simplify the setup of `$ENV`, we recommend performing all the commands as `root` (here root - is literally root, not just a user with root privileges). For the case of a dedicated server for cybernode, it should be considered as ok from the security side.*

Login as a root user

```bash
sudo -i
```

## Third-party software

The main distribution unit for Cyber is a [docker](https://www.docker.com/) container. All images are in the default [Dockerhub registry](https://hub.docker.com/r/cyberd/cyber). To access the GPU from the container, Nvidia driver version **410+** and [Nvidia docker runtime](https://github.com/NVIDIA/nvidia-docker) should be installed on the host system.

All commands below suppose `amd64` architecture, as the different architectures commands may differ accordingly.

### Install Docker

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

### Install docker-compose

Download latest version of binary from docker-compose releases [page](https://github.com/docker/compose/releases) or just do the following(asssuming that you have x86-64 architecture):

```bash
wget https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64
chmod +x docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
```

To check docker-compose is working correctly, run:

```bash
docker-compose version
```

You should get a reply with the version you have installed.

### Install Nvidia drivers

1. To proceed, first add the `ppa:graphics-drivers/ppa` repository:

   ```bash
   sudo add-apt-repository ppa:graphics-drivers/ppa
   sudo apt update
   ```

2. Install Ubuntu drivers:

   ```bash
   sudo apt install -y ubuntu-drivers-common
   ```

3. Next, check what is recommended drivers for your card:

   ```bash
   ubuntu-drivers devices
   ```

   You should see something similar to this:

   ```bash
   == /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
   modalias : pci:v000010DEd00001BA1sv00001462sd000011E4bc03sc00i00
   vendor   : NVIDIA Corporation
   model    : GP104M [GeForce GTX 1070 Mobile]
   driver   : nvidia-driver-418 - third-party free
   driver   : nvidia-driver-430 - third-party free
   driver   : nvidia-driver-440 - third-party free
   driver   : nvidia-driver-460 - third-party free recommended
   driver   : xserver-xorg-video-nouveau - distro free builtin
   ```

4. We need the **410+** drivers release. As you can see the v460 is recommended. The command below will install the recommended version of the drivers:

   ```bash
   sudo ubuntu-drivers autoinstall
   ```

   To install a specific version of a driver, use `sudo apt install nvidia-driver-460`

   The driver installation takes approximately 10 minutes.

   ```bash
   DKMS: install completed.
   Setting up libxdamage1:i386 (1:1.1.4-3) ...
   Setting up libxext6:i386 (2:1.3.3-1) ...
   Setting up libxfixes3:i386 (1:5.0.3-1) ...
   Setting up libnvidia-decode-415:i386 (460.84-0ubuntu0~gpu18.04.1) ...
   Setting up build-essential (12.4ubuntu1) ...
   Setting up libnvidia-gl-415:i386 (460.84-0ubuntu0~gpu18.04.1) ...
   Setting up libnvidia-encode-415:i386 (460.84-0ubuntu0~gpu18.04.1) ...
   Setting up nvidia-driver-415 (460.84-0ubuntu0~gpu18.04.1) ...
   Setting up libxxf86vm1:i386 (1:1.1.4-1) ...
   Setting up libglx-mesa0:i386 (18.0.5-0ubuntu0~18.04.1) ...
   Setting up libglx0:i386 (1.0.0-2ubuntu2.2) ...
   Setting up libgl1:i386 (1.0.0-2ubuntu2.2) ...
   Setting up libnvidia-ifr1-415:i386 (460.84-0ubuntu0~gpu18.04.1) ...
   Setting up libnvidia-fbc1-415:i386 (460.84-0ubuntu0~gpu18.04.1) ...
   Processing triggers for libc-bin (2.27-3ubuntu1) ...
   Processing triggers for initramfs-tools (0.130ubuntu3.1) ...
   update-initramfs: Generating /boot/initrd.img-4.15.0-45-generic
   ```

5. **Reboot** the system for the changes to take effect.

   ```bash
   sudo reboot
   ```

6. Check the installed drivers:

   ```bash
   nvidia-smi
   ```

   You should see this:
   (Some version/driver numbers might differ. You might also have some processes already running)

   ```bash
   +-----------------------------------------------------------------------------+
   | NVIDIA-SMI 460.84       Driver Version: 460.84       CUDA Version: 11.2     |
   |-------------------------------+----------------------+----------------------+
   | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
   | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
   |===============================+======================+======================|
   |   0  GeForce GTX 1070    Off  | 00000000:01:00.0 Off |                  N/A |
   | 26%   36C    P5    26W / 180W |      0MiB /  8119MiB |      2%      Default |
   +-------------------------------+----------------------+----------------------+  
   +-----------------------------------------------------------------------------+
   | Processes:                                                       GPU Memory |
   |  GPU       PID   Type   Process name                             Usage      |
   |=============================================================================|
   |  No running processes found                                                 |
   +-----------------------------------------------------------------------------+
   ```

### Install Nvidia container runtime for docker

1. Add package repositories:

   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
         && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
         && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
               sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
               sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   ```

2. Install nvidia-container toolkit and reload the Docker daemon configuration

   ```bash
   sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
   sudo systemctl restart docker
   ```

3. Test nvidia-smi with the latest official CUDA image

   ```bash
   docker run --gpus all nvidia/cuda:11.4.0-base nvidia-smi
   ```

   Output logs should coincide as earlier:

   ```bash
   Unable to find image 'nvidia/cuda:11.4.0-base' locally
   11.1-base: Pulling from nvidia/cuda
   54ee1f796a1e: Pull complete 
   f7bfea53ad12: Pull complete 
   46d371e02073: Pull complete 
   b66c17bbf772: Pull complete 
   3642f1a6dfb3: Pull complete 
   e5ce55b8b4b9: Pull complete 
   155bc0332b0a: Pull complete 
   Digest: sha256:774ca3d612de15213102c2dbbba55df44dc5cf9870ca2be6c6e9c627fa63d67a
   Status: Downloaded newer image for nvidia/cuda:11.1-base
   Mon Jun 21 14:07:52 2021 
   +------------------------------------------------------------------------+
   |NVIDIA-SMI 460.84      Driver Version:460.84      CUDA Version: 11.4    |
   |-----------------------------+--------------------+---------------------+
   |GPU  Name       Persistence-M| Bus-Id       Disp.A| Volatile Uncorr. ECC|
   |Fan  Temp  Perf Pwr:Usage/Cap|        Memory-Usage| GPU-Util  Compute M.|
   |                             |                    |               MIG M.|
   |=============================+====================+=====================|
   |  0  GeForce GTX165...  Off  |00000000:01:00.0 Off|                  N/A|
   |N/A   47C    P0   16W /  N/A |      0MB /  3914MiB|      0%      Default|
   |                             |                    |                  N/A|
   +-----------------------------+--------------------+---------------------+                                                                 
   +------------------------------------------------------------------------+
   |Processes:                                                              |
   | GPU   GI   CI       PID   Type   Process name                GPU Memory|
   |       ID   ID                                                Usage     |
   |========================================================================|
   | No running processes found                                             |
   +------------------------------------------------------------------------+
   ```

Your machine is ready to launch the cybernode.

### Domain name preparation

You will need a domain name to serve endpoints to the outer world. Use one of the domain name providers (like Namecheap) to buy one, and set up wildcard (\*) forwarding to your server *static* ip:

![use your ip address](https://gateway.ipfs.cybernode.ai/ipfs/QmbG3RPnsapfyT48YgUDTkQ9rwCvE8vdjWo3WnM7itDwzh)

If you are willing to use the second layer domain, set up wildcard forward for it as well.

### Firewall setup

To make everything work, you will need to allow specific ports on your server firewall:

```bash
sudo ufw allow 80,443,26656,4001/tcp
```

Those are necessary for Nginx, node's p2p, and ipfs p2p connections. Also, if your server is behind a NAT router, remember to set up PORT mapping for the same ports.

Also, if you're installing Grafana on a separate machine, allow port `9090` to give access to the node's metrics.

## Main part installation

Clone the repository

```bash
git clone https://github.com/cybercongress/cybernode.git && cd cybernode
```

To start cybernode, you must run the script and follow its instructions.

```bash
./start.sh
```

You can check the health of services using ***docker*** command

 ```bash
 docker ps -a
 ```

### Node snapshot application

To speed up the synchronization of the bostrom node, you may pull an archive snap from [snapshot.cybernode.ai](https://snapshot.cybernode.ai/)  and check out the snapshot [guide](https://cyb.ai/ipfs/QmciTWRWM6XFzHkwQSqhay3BEgr4pDdQVeJc6tPV1YeMfB) to get familiar with it.

### Setup monitoring

*If you decide to install Graphana on the same server as the cybernode, then be careful, because if the service fails, you may not know about it.*  

Go to your browser, and in the address bar, type: your-ip-address:3000 \
login - admin \
password - admin

*If you want, you can set your own password after this step* \
![grafana_main](https://ipfs.io/ipfs/QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD) \
Next step: Add your first data source, select 'Prometheus'
![add_dash](https://ipfs.io/ipfs/QmfVJLCVwGv3WzR6ou9opgcFcuTYRjEqQUK6TBi7vd7HSZ)
![add datasource](https://ipfs.io/ipfs/QmZhVdd262jcFRN2CzKcgWsEUoxf9C9eN4NXN4fXsA244C)
Type in the field "URL" address of your server with Prometheus and set the Name.
![datasource_edit](https://ipfs.io/ipfs/QmU62N1LqiFEKE8v372Hg1c9pXZJbzdhavKXo7N1rMB73S) \
Then click Save & test. If everything is configured correctly, a green check mark will be displayed
![save_test](https://ipfs.io/ipfs/QmYk1yqxaexPsYQvjgUNRZrDx4ayPRSyZVreGNvGkNTQHA)

For further work, you will need to find out your data source uid.
It is located in your browser address bar
![find_uid](https://ipfs.io/ipfs/QmdcCM7W7AUzccmdNnAKijHgREPyDBabhaZThqShfTDeBz)
Next step: import CyberNode dashboard to your text editor.
https://github.com/cybercongress/cybernode/blob/master/grafana_dashboard \
Then select the entire text with the ctrl + A command, turn on the search function with the ctrl + F command, find the string <PUT_YOUR_UID>, select it and replace it with your value from the previous step
![edit_board](https://ipfs.io/ipfs/QmSVUTpHBnwPF6VsTVddyXjnSvakGkyWx7kozyqsSTGais)
Repeat the previous step only this time search for the string <PUT_YOUR_HOST_NAME> and replace it with your hostname  
![](https://ipfs.io/ipfs/QmPkJWS3kXu1CNNsoeonSCS4TaVyF5jiC1mKj1fqsUL6z8)
After that, import your JSON file and click Load button
![upload_board](https://ipfs.io/ipfs/QmQYZeUpFmBUYNY4YPui4BEht2n3vPUTyLTaiCJYDXR6HH) \
Set the Name and click Import
![edit_board](https://ipfs.io/ipfs/Qmbycax2pAXJtJbZA7Ev8USYtpzLofu1PZvxFPt5dPWGqZ)
and you can notice how the graphs have come to life:
![board](https://ipfs.io/ipfs/QmeunC7yv1h77hVCmsevZHGdR8Xk8TwCWBLtnc1P7GB82G)

### Setting alerts

If you want to set up alerts to always be aware of your cybernode's work, then select the schedule that interests you and click the edit button:
![alert_find](https://ipfs.io/ipfs/QmRKB1y5uQjvkFtrXcoN6aXhhFza1fo9T5cU4YLnuLNGDC)

You will see the advanced settings of a specific schedule:

- Select an alert
- Edit all the fields that interest you
- Save before exiting

![alert_setup](https://ipfs.io/ipfs/QmPrncQeQ21ddvFLV3mnWXXprhrZ2fcrBZWp129YwDthX8)

You may use variable options to receive alerts, including [email](https://grafana.com/docs/grafana/latest/alerting/set-up/), [Telegram](https://community.grafana.com/t/telegram-alert-channel-configuration/242) or even calls.

## Congrats!

It seems like you did it! 
Open your cybernode endpoints in browser to verify them working correctly. You should have:

- `https://rpc.bostrom.<yourdomain.ai>`
- `https://lcd.bostrom.<yourdomain.ai>`
- `https://grpc.bostrom.<yourdomain.ai>`
- `https://ipfs.<yourdomain.ai>/ipfs/CID`

In case of any questions, do not hesitate to ask them in our [Telegram](https://t.me/fameofcyber)  channel for cyber Heroe's.
