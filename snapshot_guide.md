# <p style="text-align: center;">Restart Cyber with Snapshot </p>
## Download actual snapshot  
```
wget https://jupiter.cybernode.ai/shared/bostrom_pruned_5087101.tar.gz
```
## Unpack snapshot
```
tar -xvzf bostrom_pruned_5087101.tar.gz
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
cd bostrom_pruned_5087101
cp -r data/ wasm/ ~/.cyber/
```
## Start Cyber and check status  
```
docker run -d --gpus all --name=bostrom --restart always -p 26656:26656 -p 26657:26657 -p 1317:1317 -p 26660:26660 -e ALLOW_SEARCH=true -v $HOME/.cyber:/root/.cyber  cyberd/cyber:bostrom-2.1

docker exec bostrom cyber status
```
