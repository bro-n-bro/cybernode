# ![](https://ipfs.io/ipfs/QmWeAd87fZm1pMYyX9BmhnTrXYKCZLoyzMJMcSwNHfB6gU)Restart Cyber with Snapshot
## Download snapshot
First, go to [cyb snapshotrobot](https://cyb.ai/network/bostrom/contract/bostrom137p3ll78yrlw3gtfltgwhdkz0qxke4z6mt9qe6)  
You can check last block at the top of search results  
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!ТУТ БУДЕТ КАРТИНКА!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
Сlick on the link with the last block and you will see two results. The first is a hash of the current snapshot that can be downloaded via the cli using the command (to do this, you will need an 
installed ipfs)
```
ipfs add <insert the hash here>
```
The second hash is an url link that can be downloaded using the command
```
wget https://jupiter.cybernode.ai/shared/bostrom_pruned_<change block number>.tar.gz
```
or you can ask it in [Hall of Fame](https://t.me/fameofcyber)
## Unpack snapshot
```
tar -xvzf bostrom_pruned_<snap_block>.tar.gz
```
## Stop Cyber 
```
docker stop bostrom
```
## Remove old data in active directory
```
rm -rf ~/.cyber/data ~/.cyber/wasm
```
## Copy and paste unpack folders in active directory
```
cd bostrom_pruned_<snap_block>
cp -r data/ wasm/ ~/.cyber/
```
## Start Cyber and check status  
```
docker run -d --gpus all --name=bostrom --restart always -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 26660:26660 -e ALLOW_SEARCH=true -v $HOME/.cyber:/root/.cyber  cyberd/cyber:bostrom-2.1

docker exec bostrom cyber status
```
## After all you can delete unused folder and archive
```
rm -rf bostrom_pruned_<snap_block> bostrom_pruned_<snap_block>.tar.gz
```
