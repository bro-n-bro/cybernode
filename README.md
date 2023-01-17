# Provider for The Great Web

## Dream

Install nix on barebone with full sync of config from bip39 (public avatar) + cryptonote (private avatar) mnemonics

## Vision

Cybernode is a Hero's weapon in the fight for freedom and decentralization. It transforms a Hero into a Great Web provider. It is the tool to deploy, operate, maintain, and monitor major protocols required for next-generation browsers.

Checkout the [roadmap](./roadmap.md) of cybernode.

## Backend services provided by cybernode.ai

- Bostrom [RPC](https://rpc.bostrom.cybernode.ai:443)
- Bostrom [REST](https://lcd.bostrom.cybernode.ai:443)
- Bostrom [index](https://index.bostrom.cybernode.ai)
- Bostrom [websocket](wss://rpc.bostrom.cybernode.ai/websocket)
- Bostrom [GRPC](https://grpc.bstrom.cybernode.ai:1443)
- Cosmoshub-4 [RPC](https://rpc.cosmoshub-4.cybernode.ai:443)
- Cosmoshub-4 [REST](https://lcd.cosmoshub-4.cybernode.ai)
- Cosmoshub-4 [GRPC](https://grpc.cosmoshub-4.cybernode.ai:1443)
- Ethereum [RPC](https://rpc.ethereum.cybernode.ai)
- Ethereum [websocket](wss://ws.ethereum.cybernode.ai)
- Ethereum rinkeby [RPC](https://rpc-rinkeby.ethereum.cybernode.ai)
- Ethereum rinkeby [websocket](wss://ws-rinkeby.ethereum.cybernode.ai)
- IPFS [gateway](https://gateway.ipfs.cybernode.ai)

Uptime of services can be checked at [monitor](https://cybernode.ai).


## UX
https://gvolpe.com/blog/xmonad-polybar-nixos/

## Testnets endpoints
## space-pussy-1

- Space Pussy [ssl RPC](https://rpc.space-pussy-1.cybernode.ai:443), [non-ssl RPC](http://rpc.space-pussy-1.cybernode.ai:26657)
- Space Pussy [ssl REST](https://lcd.space-pussy-1.cybernode.ai:443/swagger/), [non-ssl REST](http://lcd.space-pussy-1.cybernode.ai:26317/swagger/)
- Space Pussy [ssl index](https://index.space-pussy-1.cybernode.ai:443)
- Space Pussy [ssl GRPC](https://grpc.space-pussy-1.cybernode.ai:1443), [non-ssl GRPC](http://grpc.space-pussy-1.cybernode.ai:26090)

## osmo-test-4

- Osmo [ssl RPC](https://rpc.osmo-test-4.cybernode.ai:443), [non-ssl RPC](http://rpc.osmo-test-4.cybernode.ai:26657)
- Osmo [ssl REST](https://lcd.osmo-test-4.cybernode.ai:443/swagger/), [non-ssl REST](http://lcd.osmo-test-4.cybernode.ai:26317/swagger/)
- Osmo [ssl GRPC](https://grpc.osmo-test-4.cybernode.ai:1443), [non-ssl GRPC](http://grpc.osmo-test-4.cybernode.ai:26090)

## uni-3 (juno testnet)

- Uni [ssl RPC](https://rpc.uni-3.cybernode.ai:443), [non-ssl RPC](http://rpc.uni-3.cybernode.ai:26657)
- Uni [ssl REST](https://lcd.uni-3.cybernode.ai:443), [non-ssl REST](http://lcd.uni-3.cybernode.ai:26317)
- Uni [ssl GRPC](https://grpc.uni-3.cybernode.ai:1443), [non-ssl GRPC](http://grpc.uni-3.cybernode.ai:26090)

## axelar-dojo-1

- Axelar [ssl RPC](https://rpc.axelar-dojo-1.cybernode.ai), [non-ssl RPC](http://rpc.axelar-dojo-1.cybernode.ai:26657)
- Axelar [ssl REST](https://lcd.axelar-dojo-1.cybernode.ai), [non-ssl REST](http://lcd.axelar-dojo-1.cybernode.ai:26317)
- Axelar [ssl GRPC](https://grpc.axelar-dojo-1.cybernode.ai), [non-ssl GRPC](http://grpc.axelar-dojo-1.cybernode.ai:26090)

## faucet

### space-pussy-1

curl --header "Content-Type: application/json"   --request POST   --data '{"denom":"boot","address":"bostrom14yzdndjxpgavs4cdy5qyxyg9l38rgwew38eksy"}'   https://space-pussy-1.cybernode.ai/credit

### osmo-test-4

https://discord.com/invite/osmosis

tab TESTNET channel #faucet `$request osmo1smdem8qur9jxpl8eztc4appnwek2gc63qrqaap`

### juno-test-4

https://discord.com/invite/d2CstAyjut

tab VALIDATORS channel #faucet `$request osmo1smdem8qur9jxpl8eztc4appnwek2gc63qrqaapo
