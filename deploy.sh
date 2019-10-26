#!/bin/bash

barkisd=$HOME/barkisd
barkiscli=$HOME/barkiscli

home=$HOME/.barkisd

moniker=$1
genesis=$2
seed=$3
persistent_peers=$4
gas_price=$5

$barkisd init $moniker

wget $genesis
mv genesis.json .barkisd/config/genesis.json

sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $home/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $home/config/config.toml

nohup $barkisd start --minimum-gas-prices $gas_price > barkis.log 2>&1 &
