# Сybernode roadmap

## Solve problems

- [ ] Standalone instance for balancing
- Standalone instance for monitoring
    - [ ] Pull out Prometheus from nodes to separate VPS node
- Node crash with webscocket erros
    - [ ] Disconnect index from public api
- [ ] Ethereum node for cyber.page

## Setup load balancer

- [ ] Cyber node keepalive-plugin

- Endpoints:
    - [x] rpc.euler-6.cybernode.ai
    - [x] lcd.euler-6.cybernode.ai
    - [ ] index.euler-6.cybernode.ai
    - [ ] rpc.bostrom.cybernode.ai
    - [ ] lcd.bostrom.cybernode.ai
    - [ ] index.bostrom.cybernode.ai
    - [ ] rpc.cosmoshub-3.cybernode.ai
    - [ ] lcd.cosmoshub-3.cybernode.ai
    - [ ] rpc.ethereum.cybernode.ai
    - [ ] ws.ethereum.cybernode.ai
    - [ ] rpc-rinkeby.ethereum.cybernode.ai
    - [ ] ws-rinkeby.ethereum.cybernode.ai
    - [ ] gateaway.ipfs.cybernode.ai
    - [ ] cluster.ipfs.cybernode.ai

## Monitoring

- [ ] Actionable notifications for telegram
- [ ] Endppoint uptime monitoring
- [ ] Setup Postgress exporter for Cyberindex
- [ ] Setup export of nginx metrics to prometheus
- [ ] Dashboard for nginx (count requests such as search, data etc)
- [ ] Add GPU metrics to Grafana (glances)
- [ ] Make grafana dash for Bostrom

## Reproducable infrustructure

- new architechture
    - diagram
    - identical GPU machines with storage for redundancy
- [ ] container for load-balancer
- [ ] container for monitoring
    - [ ] deploy scripts of Prometheus, Grafana, node_exp, glances, cadvisor to Git
    - [ ] grafana dashes to git and publish to Grafana
- [ ] container for go-cyber (euler-6)
- [ ] container for go-cyber (bostrom)
- [ ] container for cyber-index
- [ ] container for gaia
- [ ] container for go-ethereum
- [ ] container for ifps-node
- [ ] container for ifps-cluster
- [ ] k8s config
- Documentation

## Monetization infrustrucutre

- token based auth for rate limiting

## Service for team

- Identify requrements from the team
- Vpn
- Ethereum node
