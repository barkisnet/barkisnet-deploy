#!/bin/bash

barkisd=$HOME/barkisd
barkiscli=$HOME/barkiscli

home=$HOME/.barkisd

configFile=$1
moniker=$(jq -r .moniker $configFile)
genesis=$(jq -r .genesis $configFile)
seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

$barkisd init $moniker

wget $genesis
mv genesis.json .barkisd/config/genesis.json

sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $home/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $home/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $home/config/config.toml
