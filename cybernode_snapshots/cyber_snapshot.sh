#!/bin/bash
#
# IMPORTANT!!!
# Replace the important values of the variables with your own
#
# This script has several main features:
#   1. Create a snapshot of the current state
#   2. Adding a snapshot (and removing the old one) to the local IPFS node
#   3. Linking a snapshot to Cybergraph
# If you want to use the functions of linking or adding a snapshot to IPFS - uncomment the corresponding lines of code:
# 40 - 47, 62 - 92
# You will also need to set up a local ipfs node and add the key to the keyring-backend test for linking to Cybergraph
#
PATH='/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin'
CHAIN_ID="bostrom"
SNAP_PATH="</path/to/snapshot/folder>"
LOG_PATH="</path/to/log/file>"
DATA_PATH="/root/.cyber"
SERVICE_NAME="bostrom"
LAST_BLOCK_HEIGHT=$(docker exec -t bostrom cyber status | jq -r .SyncInfo.latest_block_height)
SNAP_NAME=$(echo "${CHAIN_ID}_${LAST_BLOCK_HEIGHT}_$(date '+%Y-%m-%d').tar")
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar")
IPFS_HASH="/path/to/ipfs_hash_file"
export IPFS_PATH="</path/to/ipfs/folder"
export CYBER_PATH="/root/.cyber"

now_date() {
    echo -n $(TZ=":Europe/Moscow" date '+%Y-%m-%d_%H:%M:%S')
}

log_this() {
    YEL='\033[1;33m' # yellow
    NC='\033[0m'     # No Color
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

log_this "remove and create cyber log file"
rm ${LOG_PATH}
touch ${LOG_PATH}

# This command is required to unpin your snap from ipfs
#log_this "remove old ipfs pins"
#ipfs pin rm ${IPFS_HASH} >> ${LOG_PATH}

# This command clear your ipfs garbage collection
#log_this "remove old ipfs garbage"
#ipfs repo gc >> ${LOG_PATH}
#sleep 8

log_this "LAST_BLOCK_HEIGHT ${LAST_BLOCK_HEIGHT}"

log_this "Stopping ${SERVICE_NAME}"
docker stop ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

log_this "Creating new snapshot"
time tar --exclude='bak' --exclude='config' --exclude='cosmovisor' --exclude='cuda-keyring_1.0-1_all.deb' --exclude='priv_validator_key.json' --exclude='cache' -zcvf ${SNAP_PATH}/${SNAP_NAME} -C ${DATA_PATH} . ; echo $? >> ${LOG_PATH}


log_this "Removing old snapshot(s):"
cd ${SNAP_PATH} >> ${LOG_PATH}
rm -fv ${OLD_SNAP} >> ${LOG_PATH}

#log_this "add snapshot to ipfs and to file and last block to file"
#ipfs add ${SNAP_PATH}/${SNAP_NAME} | grep -o '\Q\w*' &> </path/to/ipfs_hash_file> ; echo $? >> ${LOG_PATH}
#echo ${LAST_BLOCK_HEIGHT} &> </path/to/ipfs_block_file> ; echo $? >> ${LOG_PATH}

#log_this "add block to ipfs"
#ipfs add </path/to/ipfs_block_file> | grep -o '\Q\w*' &> </path/to/ipfs_block_hash_file> ; echo $? >> ${LOG_PATH}

#log_this "add snapshot url to file"
#echo  https://</your/website/url>/${SNAP_NAME} &> </path/to/snap_url_file> ; echo $? >> ${LOG_PATH}

#log_this "add snapshot url to ipfs"
#ipfs add </path/to/snap_url_file> | grep -o '\Q\w*' &> </path/to/snap_url_hash_file> ; echo $? >> ${LOG_PATH}

#SNAP_URL_HASH="</path/to/snap_url_hash_file>"
#SNAP_URL="</path/to/snap_url_file>"
#SNAPSHOT_HASH="</path/to/snapshot_hash_file>" # snapshot hash QmTZsqqc3kGGzc3Vd8bh8TvYbyS5mqxvM4spKMej9eRJvG
#IPFS_HASH="</path/to/ipfs_hash_file>"
#IPFS_BLOCK="</path/to/ipfs_block_file>"
#IPFS_BLOCK_HASH="</path/to/ipfs_block_hash_file>"
#TWEET_HASH="</path/to/tweet_hash_file>"
#MANUAL="</path/to/manual_file>" # cyber_script manual hash QmciTWRWM6XFzHkwQSqhay3BEgr4pDdQVeJc6tPV1YeMfB

#log_this "add cyberlinks from snapshot to block number and from block number to actual snap"
#sleep 8
#cyber tx graph cyberlink $(cat ${TWEET_HASH}) $(cat ${IPFS_BLOCK_HASH}) --from <your_account_name> --keyring-backend <your_keyring> --chain-id bostrom -y &>> ${LOG_PATH}
#sleep 8
#cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${IPFS_HASH}) --from <your_account_name> --keyring-backend <your_keyring> --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}
#sleep 8
#cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${SNAP_URL_HASH}) --from <your_account_name> --keyring-backend <your_keyring> --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}
#sleep 8
#cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${MANUAL}) --from <your_account_name> --keyring-backend <your_keyring> --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}

log_this "Starting ${SERVICE_NAME}"
docker container start ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

du -hs ${SNAP_PATH}/${SNAP_NAME} | tee -a ${LOG_PATH}

log_this "Done\n---------------------------\n"
