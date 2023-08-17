#!/bin/bash

# Define the ASCII art
art=$(echo "
             __        _______ _     ____ ___  __  __ _____   _____ ___
             \ \      / / ____| |   / ___/ _ \|  \/  | ____| |_   _/ _ \\
              \ \ /\ / /|  _| | |  | |  | | | | |\/| |  _|     | || | | |
               \ V  V / | |___| |__| |__| |_| | |  | | |___    | || |_| |
                \_/\_/  |_____|_____\____\___/|_|  |_|_____|   |_| \___/


                  ______   ______  _____ ____  _   _  ___  ____  _____
                 / ___\ \ / / __ )| ____|  _ \| \ | |/ _ \|  _ \| ____|
                | |    \ V /|  _ \|  _| | |_) |  \| | | | | | | |  _|
                | |___  | | | |_) | |___|  _ <| |\  | |_| | |_| | |___
                 \____| |_| |____/|_____|_| \_\_| \_|\___/|____/|_____|

                                   ..',,;;,,'..
                            .;ok0NWMMMMMMMMMMMMWX0xl,.
                        .ckNMMMMMMMMMMMMMMMMMMMMMMMMMMXd;.
                      ,OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd.
                    .OMMMMMMMMMMMMMWNXK0000KXWWMMMMMMMMMMMMMx.
                   :WMMMMMMMMMXxc,.            .;oONMMMMMMMMMN'
                  .WMMMMMMMXl.                      ,xWMMMMMMMN.
                  lMMMMMMWc                           .kMMMMMMM:  .
              .x; ;MMMMMM:   'cll:'.          .;cllc.   kMMMMMM, .X:
             ;NMx  OMMMMM.  .oxxxxd:.        .lxxxdxc.  ;MMMMMO  oMMO..
            oMMMW'..kWMMMd   'loddo;         .:oddoc.   0MMMMx...NMMMK,
           cMMMMMX;..;0MMMk.   ...              ...   .0MMM0;..:XMMMMMO
           KMMMMMMWk;..'oKMWO:.                    .c0MMXx,..lKMMMMMMMM.
          .KMMMMMMMMMNd,  .:d0NXkl:'..      ..':okXWKkl,..l0WMMMMMMMMMN
          'cWMMMMMMMMMMMXc    ..;ldxO0000KK00Okdo:,..   dNMMMMMMMMMMMWc
            cWMMMMMMMMMMMMK:'                         cXMMMMMMMMMMMMNc
             :0MMMMMMMMMMMMWo.                       dWMMMMMMMMMMMWO:
              'cKMMMMMMMMMMMMx.                    .xMMMMMMMMMMMWO;'
                 ;kNMMMMMMMMMMd                    dMMMMMMMMMMKo'
                     ckNMMMMMMMW,                  'WMMMMMMW0o'
                        'l0NMMMMd..                cMMMW0o;.
")

# Display the ASCII art
echo "$art"

# Step 1: Ask user to enter a domain name
message=$(cat <<EOF
For installation, you will need:
  - Domain name to provide endpoints
  - Open ports:
      - Port 80 (HTTP)
      - Port 443 (HTTPS)
      - Port 26656 (BOSTROM)
      - Port 4001 (IPFS)
 - Email to receive SSL certificates (optional)
EOF
)

echo "$message"

read -p "STEP 1: Please enter domain name: " domain

# Step 1.1: Domain name clarification check
while true; do
    read -p "Do you want to use the domain name '$domain'? (y/n): " confirmation
    if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
        break
    elif [[ $confirmation == "n" || $confirmation == "N" ]]; then
        read -p "Enter the domain name: " domain
    else
        echo "Invalid input. Please enter 'y' or 'n'."
    fi
done

# Step 2: Insert domain name into the .env file
sed -i -E "s/^(DOMAIN=).*/\1${domain}/" .env

# Step 3: Insert domain name into prometheus.yml
sed -i -e "s#- https://.*:9115#- https://bostrom.$domain:9115#" \
       -e "s#- https://rpc.bostrom\..*/block?height=8733522#- https://rpc.bostrom.$domain/block?height=8733522#" \
       -e "s#- https://lcd.bostrom\..*/node_info#- https://lcd.bostrom.$domain/node_info#" \
       -e "s#- https://ipfs\..*/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG/readme#- https://ipfs.$domain/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG/readme#" prometheus.yml

# Step 3.1: Display updated lines from prometheus.yml
echo "Following endpoint list will be provided by your Hero"
grep -E "(https?|rpc\.|lcd\.|ipfs\.|$domain:9115)" prometheus.yml | grep -v -e "module: \[http_prometheus\]" -e "- targets: # Target to probe with https."
echo "Domain name has been updated successfully."

# Step 3.2: Ping rpc.<DOMAIN_NAME> and display IP address
rpc_domain="rpc.$domain"
echo "STEP 2: Pinging $rpc_domain..."
ping_result=$(ping -c 1 $rpc_domain)

# Check if ping result contains an IP address
if echo "$ping_result" | grep -qE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'; then
    ip_address=$(echo "$ping_result" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    echo "The IP address of $rpc_domain is: $ip_address"
else
    echo "ERROR: Unable to retrieve IP address for $rpc_domain."
    exit 1  # Exit the script with an error code
fi

# Step 3.3: Confirm IP address ownership
read -p "Does the IP address $ip_address belong to you? (y/n): " ip_confirmation

if [[ $ip_confirmation == "y" || $ip_confirmation == "Y" ]]; then
    echo "IP address ownership confirmed."
else
    echo "Please ensure the correct IP address is assigned to your domain and try again."
    exit 1
fi

# Step 4: Ask user if they want to use email for SSL certificates
read -p "STEP 3: Do you want to use email to obtain SSL certificates? (y/n): " use_email

if [[ $use_email == "y" || $use_email == "Y" ]]; then
  while true; do
    read -p "Enter email: " email
    read -p "Do you want to use the email '$email'? (y/n): " confirmation
    if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
      sed -i -E "s/^(EMAIL=).*/\1${email}/" .env
      sed -i '/certbot:/,/command: certonly/ s/--register-unsafely-without-email/--email ${EMAIL}/' docker-compose-init.yml docker-compose.yml
      break
    elif [[ $confirmation == "n" || $confirmation == "N" ]]; then
      continue
    else
      echo "Invalid input. Please enter 'y' or 'n'."
    fi
  done
fi

if [[ $use_email == "n" || $use_email == "N" ]]; then
  sed -i '/certbot:/,/command: certonly/ s/--email ${EMAIL}/--register-unsafely-without-email/' docker-compose-init.yml docker-compose.yml
fi

# Step 5: Open Ports
# Check if ufw is active
echo "STEP 4: Enable ufw and open ports"
ufw_status=$(sudo ufw status | grep -o "Status: active")

if [[ "$ufw_status" == "Status: active" ]]; then
    echo "ufw is already active."
    read -p "The following ports will be open:
     - Port 80 (HTTP)
     - Port 443 (HTTPS)
     - Port 26656 (BOSTROM)
     - Port 4001 (IPFS)
    Do you want to allow these ports and start running Hero node? (y/n): " answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        sudo ufw allow 80
        sudo ufw allow 443
        sudo ufw allow 26656
        sudo ufw allow 4001
        echo "Ports allowed successfully."
    else
        echo "WARNING: If the required ports are not open, the application may not function properly."
        echo "WARNING: Please configure your firewall to allow the following ports after the script finishes:"
    fi
else
    read -p "ufw is not active. Do you want to activate ufw and allow the required ports? (y/n): " activate_ufw

    if [[ "$activate_ufw" == "y" || "$activate_ufw" == "Y" ]]; then
        sudo ufw enable
        sudo ufw allow 80
        sudo ufw allow 443
        sudo ufw allow 26656
        sudo ufw allow 4001
        echo "UFW activated and ports allowed successfully."
    else
	echo "WARNING: If the required ports are not open, the application may not function properly."
        echo "WARNING: Please configure your firewall to allow the following ports after the script finishes:"
    fi
fi

# Step 6: Check nvidia
echo "STEP 5: Checking if the drivers are installed"

nvidia-smi &> /dev/null
if [[ $? -eq 0 ]]; then
	  echo "Success! Nvidia driver is installed."
  else
	    echo "Error: Nvidia driver is not installed or not detected."
fi

# Step 7: Start docker-compose-init.yml
echo "STEP 6: Getting certificates to start your node"
docker-compose -f docker-compose-init.yml up -d

# Step 8: Check if docker-compose-init.yml started successfully
if [ $? -eq 0 ]; then
    echo "docker-compose-init.yml started successfully."
    echo "STEP 7: Wait a minute for your Hero Node to start"
    # Step 8: Start docker-compose.yml
    sleep 60
    docker-compose -f docker-compose.yml up -d
else
    echo "Failed to start docker-compose-init.yml. Aborting."
fi
