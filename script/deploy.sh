#!/bin/bash

barkisd=$HOME/barkisd
barkiscli=$HOME/barkiscli

home=$HOME/.barkisd

configUrl=$1

wget $configUrl/binary/barkisd
wget $configUrl/binary/barkiscli
wget $configUrl/genesis.json
wget $configUrl/networkConfig.json

chmod +x barkisd
chmod +x barkiscli

configFile=networkConfig.json

moniker=$(jq -r .moniker $configFile)
seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

$barkisd init $moniker

mv genesis.json .barkisd/config/genesis.json

sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $home/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $home/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $home/config/config.toml
