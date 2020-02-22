# Deploy

## Command


```shell
sudo apt update
```

```shell
wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/single-validator/deploy.sh -O deploy.sh && sh deploy.sh [binVersion] [moniker] [miniGasPrice]
```

Example command:

```shell
wget https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master/mainnet/single-validator/deploy.sh -O deploy.sh && sh v2.2.1 deploy.sh myBarkisNode 0.01ubarkis
```
