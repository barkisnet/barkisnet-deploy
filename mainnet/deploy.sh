#!/bin/sh

moniker=$1
gas_price=$2

jqPath=$(which jq)
if [ -z "$jqPath" ]
then
      sudo apt-get install jq -y
fi

curDir=$(pwd)
username=$USER
nodeHome=barkisNode
configUrl=https://raw.githubusercontent.com/barkisnet/barkisnet-binary/master/barkisnet-mainnet

wget $configUrl/binary/barkisd
wget $configUrl/binary/barkiscli
wget $configUrl/genesis.json
wget $configUrl/networkConfig.json
wget $configUrl/barkis-validator-daemon
wget $configUrl/barkis-validator-daemon.service

configFile=networkConfig.json

seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

chmod +x barkisd
chmod +x barkiscli
chmod +x barkis-validator-daemon

sed -i -e "s@{{WORKDIR}}@$curDir@g" barkis-validator-daemon
sed -i -e "s@{{BARKIS_HOME}}@$nodeHome@g" barkis-validator-daemon
sed -i -e "s@{{MINI_GAS_PRICE}}@$gas_price@g" barkis-validator-daemon
sed -i -e "s@{{USER_NAME}}@$username@g" barkis-validator-daemon
sed -i -e "s@{{USER_GROUP}}@$username@g" barkis-validator-daemon

sudo cp barkis-validator-daemon /etc/init.d/
sudo cp barkis-validator-daemon.service /etc/systemd/system

./barkisd init $moniker --home $nodeHome
cp genesis.json $nodeHome/config/genesis.json
sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $nodeHome/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $nodeHome/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $nodeHome/config/config.toml

sudo systemctl daemon-reload

sudo systemctl start barkis-validator-daemon
