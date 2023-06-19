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
sed -i -e "s#- https://.*:9115#- https://$domain:9115#" \
       -e "s#- https://rpc\..*/block?height=7278626#- https://rpc.$domain/block?height=7278626#" \
       -e "s#- https://lcd\..*/node_info#- https://lcd.$domain/node_info#" \
       -e "s#- https://index\..*/console/#- https://index.$domain/console/#" \
       -e "s#- https://ipfs\..*/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG/readme#- https://ipfs.$domain/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG/readme#" prometheus.yml

# Step 3.1: Display updated lines from prometheus.yml
echo "Following endpoint list will be provided by your Hero"
grep -E "(https?|rpc\.|lcd\.|index\.|ipfs\.|$domain:9115)" prometheus.yml | grep -v -e "module: \[http_prometheus\]" -e "- targets: # Target to probe with https."
echo "Domain name has been updated successfully."

# Step 4: Ask user if they want to use email for SSL certificates
read -p "STEP 2: Do you want to use email to obtain SSL certificates? (y/n): " use_email

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
read -p "STEP 3: The following ports will be open:
 - Port 80 (HTTP)
 - Port 443 (HTTPS)
 - Port 26656 (BOSTROM)
 - Port 4001 (IPFS)

Do you want to allow these ports and start running Hero node? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    ufw allow 80
    ufw allow 443
    ufw allow 26656
    ufw allow 4001
    echo "Ports allowed successfully."
else
    echo "No action taken. Ports are not allowed."
fi

# Step 6: Start docker-compose-init.yml
echo "Getting certificates to start your node"
docker-compose -f docker-compose-init.yml up -d

# Step 7: Check if docker-compose-init.yml started successfully
if [ $? -eq 0 ]; then
    echo "docker-compose-init.yml started successfully."
    echo "Wait a minute for your Hero Node to start"
    # Step 8: Start docker-compose.yml
    sleep 60
    docker-compose -f docker-compose.yml up -d
else
    echo "Failed to start docker-compose-init.yml. Aborting."
fi
