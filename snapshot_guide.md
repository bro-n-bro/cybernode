# ![](https://ipfs.io/ipfs/QmWeAd87fZm1pMYyX9BmhnTrXYKCZLoyzMJMcSwNHfB6gU)Restart Cyber with Snapshot
## Download snapshot
First, go to <a href="https://cyb.ai/network/bostrom/contract/bostrom137p3ll78yrlw3gtfltgwhdkz0qxke4z6mt9qe6" target="_blank">Cyb Snapshot Robot</a>  
You can check last block at the top of search results  
![](https://ipfs.io/ipfs/QmWjcgseTj5GmGSC8z1X6wzD5Eh1wQv1RfBfChmafqcwvm)  
Сlick on the link with the last block and you will see two results.  
![](https://ipfs.io/ipfs/QmQvZegg39JnQ5EESgA3t9seCYSAF7nZyDZGRo1iUXLemi)  
The first is a hash of the current snapshot that can be downloaded over ipfs using the command:  
(to use this way, you need an installed ipfs)  
```
ipfs get <insert the hash here> -O bostrom_pruned.tar.gz
```
The second hash contains url that can be downloaded using

```
wget https://jupiter.cybernode.ai/shared/bostrom_pruned_<change block number>.tar.gz
```

## Unpack snapshot

Single thread:

```
tar -xvzf bostrom_pruned_<snap_block>.tar.gz
```

Multiple threads (require pigz installation):

```
apt install pigz
tar -I pigz -xf bostrom_pruned_<snap_block>.tar.gz -C ./
```

## Stop Cyber 

```
docker stop bostrom
```

## Remove old data from home directory

```
rm -rf ~/.cyber/data ~/.cyber/wasm
```

## Move unpacked folders into home directory

**Dont forget to use correct path if your node is not in $HOME of user.**
```
cd bostrom_pruned_<snap_block>
mv data/ ~/.cyber/
mv wasm/ ~/.cyber/
```

## Set up your pruning strategy to everything

To save the space consumed by the node set pruning to everything (most light) and set snapshot-interval to 0 in `.cyber/config/app.toml`:

```
pruning = "default"
snapshot-interval = 0
```

## Start Cyber container and check logs  
```
docker start bostrom
docker logs bostrom -f --tail 10
```

## When done remove folder and archive to save some space

```
rm -rf bostrom_pruned_<snap_block> bostrom_pruned_<snap_block>.tar.gz
```
