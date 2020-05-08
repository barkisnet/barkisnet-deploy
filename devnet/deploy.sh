#!/bin/sh

moniker=$1
gas_price=$2

if [ -z "$moniker" ] || [ -z "$gas_price" ]
then
  echo "Wrong usage!! Correct usage: sh deploy.sh [moniker] [mini_gas_price]"
  exit 0
fi

sudo apt update

jqPath=$(which jq)
if [ -z "$jqPath" ]
then
  sudo apt install jq -y
fi

jqPath=$(which jq)
if [ -z "$jqPath" ]
then
  echo "Install jq failed, abort!"
  exit 0
fi

curDir=$(pwd)
username=$USER
nodeHome=barkisNode
networkType=barkisnet-devnet
configUrl=https://raw.githubusercontent.com/barkisnet/barkisnet-binary/master

wget $configUrl/$networkType/binary/barkisd -O barkisd
wget $configUrl/$networkType/binary/barkiscli -O barkiscli
wget $configUrl/$networkType/genesis.json -O genesis.json
wget $configUrl/$networkType/networkConfig.json -O networkConfig.json
wget $configUrl/$networkType/barkis-validator-daemon -O barkis-validator-daemon
wget $configUrl/$networkType/barkis-validator-daemon.service -O barkis-validator-daemon.service

configFile=networkConfig.json

seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

chmod +x barkisd
chmod +x barkiscli
chmod +x barkis-validator-daemon

sed -i -e "s@{{WORKDIR}}@$curDir@g" barkis-validator-daemon
sed -i -e "s@{{BARKIS_HOME}}@$nodeHome@g" barkis-validator-daemon
sed -i -e "s@{{USER_NAME}}@$username@g" barkis-validator-daemon
sed -i -e "s@{{USER_GROUP}}@$username@g" barkis-validator-daemon

sudo cp barkis-validator-daemon /etc/init.d/
sudo cp barkis-validator-daemon.service /etc/systemd/system

./barkisd init $moniker --home $nodeHome
cp genesis.json $nodeHome/config/genesis.json
sed -i -e "s/minimum-gas-prices = \"\"/minimum-gas-prices = \"$gas_price\"/g" $nodeHome/config/app.toml
sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $nodeHome/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $nodeHome/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $nodeHome/config/config.toml
sed -i -e "s/timeout_commit = \"1s\"/timeout_commit = \"5s\"/g" barkisNode/config/config.toml

sudo systemctl daemon-reload

sudo systemctl start barkis-validator-daemon
