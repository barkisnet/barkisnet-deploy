# Deploy validator and sentry nodes

## Deploy sentry node

```shell
cd $HOME && wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/sentry-validator/deploy-sentry.sh -O deploy-sentry.sh && sh deploy-sentry.sh [moniker] [miniGasPrice]
```

Example command:

```shell
cd $HOME && wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/deploy.sh -O deploy.sh && sh deploy.sh myBarkisNode 0.01ubarkis
```

## Deploy validator node

- Deploy validator
```shell
cd $HOME && wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/sentry-validator/deploy-validator.sh -O deploy-validator.sh && sh deploy-validator.sh [moniker] [miniGasPrice]
```
- Get validator node id
```
cd $HOME && ./barkisd tendermint show-node-id --home $HOME/barkisNode
```


## Private validator on sentry node

```shell
wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/sentry-validator/private-validator.sh -O private-validator.sh && sh private-validator.sh [validator-node-id] [node-home-path]
```

Example command:

```shell
cd $HOME && wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/sentry-validator/private-validator.sh -O private-validator.sh && sh private-validator.sh acc6a758e843dde12fecdeccdf18f1c54f5f2961 $HOME/barkisNode
```
