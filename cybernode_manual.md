# Welcome To Cybernode

## What is it for

Сybernode is designed to help Сyber decentralize and make Validators also Content Providers.  
In order to implement this, each participant will provide api endpoints (rpc, lcd, grpc) to connect to the cyb.ai app.

## Requirements

```
Server: Static ip address, domain name
CPU: 6 cores
RAM: 32 GB
SSD: 4+ TB NVME SSD
Connection: 50+Mbps, Stable and low-latency connection
GPU: Nvidia GeForce (or Tesla/Titan/Quadro) with CUDA-cores; 4+ Gb of video memory*
Software: Ubuntu 18.04 LTS / 20.04 LTS
Optional: VPS for Grafana monitoring server (standard config for Cybernode includes automatic installation)
```

## Node setup

*To avoid possible misconfiguration issues and simplify the setup of `$ENV`, we recommend to perform all the commands as `root` (here root - is literally root, not just a user with root priveliges). For the case of a dedicated server for cybernode it should be concidered as ok from the security side.*

Login as a root user

```
sudo -i
```

### Third-party software

The main distribution unit for Cyber is a [docker](https://www.docker.com/) container. All images are located in the default [Dockerhub registry](https://hub.docker.com/r/cyberd/cyber). In order to access the GPU from the container, Nvidia driver version **410+** and [Nvidia docker runtime](https://github.com/NVIDIA/nvidia-docker) should be installed on the host system.

All commands below suppose `amd64` architecture, as the different architectures commands may differ accordingly.

### Docker installation

Simply copy the commands below and paste into CLI.

1. Update the `apt` package index:

```bash
sudo apt-get update
```

2. Install packages to allow apt to use a repository over HTTPS:

```bash
sudo apt install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg-agent \
     software-properties-common
```

3. Add Docker’s official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

4. Update the apt package index:

```bash
sudo apt update
```

5. Install the latest version of Docker CE and containerd:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### Installing Nvidia drivers

1. To proceed, first add the `ppa:graphics-drivers/ppa` repository:

```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
```

```bash
sudo apt update
```

2. Install Ubuntu-drivers:

```bash
sudo apt install -y ubuntu-drivers-common
```

3. Next check what are recommended drivers for your card:

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

To install specific version of a driver use `sudo apt install nvidia-driver-460`


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

#### Install Nvidia container runtime for docker

1. Add package repositories:

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
```

```bash
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
```

```bash
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

You should see something like this:

```bash
deb https://nvidia.github.io/libnvidia-container/ubuntu20.04/$(ARCH) /
deb https://nvidia.github.io/nvidia-container-runtime/ubuntu20.04/$(ARCH) /
deb https://nvidia.github.io/nvidia-docker/ubuntu20.04/$(ARCH) /
```

2. Install nvidia-container toolkit and reload the Docker daemon configuration

```bash
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
```

```bash
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

Your machine is ready to launch the node.

### Clone the repository
```
git clone https://github.com/cybercongress/cybernode.git && cd cybernode
```

### Running the script
To start cybernode you need to run the script and follow its instructions
```
chmod 700 start.sh
./start.sh
```

### CHECK
You can check the health of services using ***docker*** command
 ```
 docker ps -a
 ```

### Setup monitoring
*If you decide to install graphana on the same server as the cybernode, then be careful, because if the service fails, you may not know about it*  

Go to your browser and in the address bar type: your-ip-address:3000 \
login - admin \
password - admin 

*If you want you can set your own password after this step* \
![](https://ipfs.io/ipfs/QmVEKi8fuxPQpoF5SYbJn7pW6CWaKsEDa3SLLuGXSZn8eD) \
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
https://github.com/cybercongress/cybernode/blob/master/grafana_dashboard \
Then select the entire text with the ctrl + A command, turn on the search function with the ctrl + F command, find the ***uid*** value, in my case it is 000000003, select it and replace it with your value from the previous step 
![](https://ipfs.io/ipfs/QmZhUTznQ7ShRPzJC4NSrbn29fVKbX6DtW5cXg61wKNyrK)
After that, import your json file and click Load button
![](https://ipfs.io/ipfs/QmQYZeUpFmBUYNY4YPui4BEht2n3vPUTyLTaiCJYDXR6HH) \
Set the Name and click Import 
![](https://ipfs.io/ipfs/Qmbycax2pAXJtJbZA7Ev8USYtpzLofu1PZvxFPt5dPWGqZ)
and you can notice how the graphs have come to life:
![](https://ipfs.io/ipfs/QmeunC7yv1h77hVCmsevZHGdR8Xk8TwCWBLtnc1P7GB82G)

### Setting alerts
If you want to set up alerts to always be aware of your cybernode's work, then select the schedule that interests you and click edit button:
![](https://ipfs.io/ipfs/QmRKB1y5uQjvkFtrXcoN6aXhhFza1fo9T5cU4YLnuLNGDC)
You will see the advanced settings of a specific schedule:
- Select an alert
- Edit all the fields that interest you
- Save before exiting

![](https://ipfs.io/ipfs/QmPrncQeQ21ddvFLV3mnWXXprhrZ2fcrBZWp129YwDthX8)
## GOOD LUCK!