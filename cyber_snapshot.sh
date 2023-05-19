#!/bin/bash
PATH='/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin'
CHAIN_ID="bostrom_pruned"
SNAP_PATH="/mnt/nvme4tb/shared"
LOG_PATH="/mnt/nvme4tb/snapshots/cyber/cyber_log.txt"
DATA_PATH="/mnt/nvme4tb/.cyber/"
SERVICE_NAME="bostrom_pruned"
RPC_ADDRESS="http://localhost:28957"
LAST_BLOCK_HEIGHT=$(docker exec -t bostrom_pruned cyber status | jq -r .SyncInfo.latest_block_height)
SNAP_NAME=$(echo "${CHAIN_ID}_${LAST_BLOCK_HEIGHT}_$(date '+%Y-%m-%d').tar")
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar")
IPFS_HASH="/mnt/nvme4tb/shared/ipfs_hash"
export IPFS_PATH="/mnt/nvme4tb/.ipfs"
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
rm /mnt/nvme4tb/snapshots/cyber/cyber_log.txt
touch /mnt/nvme4tb/snapshots/cyber/cyber_log.txt

log_this "remove old ipfs pins"
ipfs pin rm ${IPFS_HASH}

log_this "remove old ipfs garbage"
ipfs repo gc
sleep 8

log_this "LAST_BLOCK_HEIGHT ${LAST_BLOCK_HEIGHT}"

log_this "Stopping ${SERVICE_NAME}"
docker stop ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

log_this "Creating new snapshot"
time tar --exclude='bak' --exclude='config' --exclude='cosmovisor' --exclude='cuda-keyring_1.0-1_all.deb' --exclude='priv_validator_key.json' --exclude='cache' -zcvf ${SNAP_PATH}/${SNAP_NAME} -C ${DATA_PATH} .

log_this "Removing old snapshot(s):"
cd ${SNAP_PATH}
rm -fv ${OLD_SNAP} &>>${LOG_PATH}

log_this "add snapshot to ipfs and to file and last block to file"
ipfs add ${SNAP_PATH}/${SNAP_NAME} | grep -o '\Q\w*' &> /mnt/nvme4tb/shared/ipfs_hash ; echo ${LAST_BLOCK_HEIGHT} &> /mnt/nvme4tb/shared/ipfs_block

log_this "add block to ipfs"
ipfs add /mnt/nvme4tb/shared/ipfs_block | grep -o '\Q\w*' &> /mnt/nvme4tb/shared/ipfs_block_hash

log_this "add snapshot url to file"
echo  https://jupiter.cybernode.ai/shared/${SNAP_NAME} &> /mnt/nvme4tb/shared/snap_url

log_this "add snapshot url to ipfs"
ipfs add /mnt/nvme4tb/shared/snap_url | grep -o '\Q\w*' &> /mnt/nvme4tb/shared/snap_url_hash

STATIC="/mnt/nvme4tb/shared/static"
SNAP_URL_HASH="/mnt/nvme4tb/shared/snap_url_hash"
SNAP_URL="/mnt/nvme4tb/shared/snap_url"
SNAPSHOT_HASH="/mnt/nvme4tb/shared/snapshot_hash"
IPFS_HASH="/mnt/nvme4tb/shared/ipfs_hash"
IPFS_BLOCK="/mnt/nvme4tb/shared/ipfs_block"
IPFS_BLOCK_HASH="/mnt/nvme4tb/shared/ipfs_block_hash"
TWEET_HASH="/mnt/nvme4tb/shared/tweet_hash"
MANUAL="/mnt/nvme4tb/shared/manual"

log_this "add cyberlinks from snapshot to block number and from block number to actual snap"
sleep 8
cyber tx graph cyberlink $(cat ${TWEET_HASH}) $(cat ${IPFS_BLOCK_HASH}) --from snapshot_bot --keyring-backend test --chain-id bostrom -y &>> ${LOG_PATH}
sleep 8
cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${IPFS_HASH}) --from snapshot_bot --keyring-backend test --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}
sleep 8
cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${SNAP_URL_HASH}) --from snapshot_bot --keyring-backend test --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}
sleep 8
cyber tx graph cyberlink $(cat ${IPFS_BLOCK_HASH}) $(cat ${MANUAL}) --from snapshot_bot --keyring-backend test --chain-id bostrom --gas 700000 --gas-prices 0.01boot -y &>> ${LOG_PATH}

log_this "Starting ${SERVICE_NAME}"
docker container start ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

du -hs ${SNAP_PATH}/${SNAP_NAME} | tee -a ${LOG_PATH}

log_this "Done\n---------------------------\n"
