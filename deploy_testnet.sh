#!/bin/sh

moniker=$1
gas_price=$2

jqPath=$(which jq)
if [ -z "$jqPath" ]
then
      sudo apt-get install jq -y
fi

nodeHome=./barkisNode
configUrl=https://raw.githubusercontent.com/pengqi-bc/testnet/master/barkisnet-test

wget $configUrl/binary/barkisd
wget $configUrl/binary/barkiscli
wget $configUrl/genesis.json
wget $configUrl/networkConfig.json

configFile=networkConfig.json

seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

chmod +x barkisd
chmod +x barkiscli

./barkisd init $moniker --home $nodeHome
cp genesis.json $nodeHome/config/genesis.json
sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $nodeHome/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $nodeHome/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $nodeHome/config/config.toml

nohup ./barkisd start --home $nodeHome --minimum-gas-prices $gas_price > barkisd.log 2>&1 &