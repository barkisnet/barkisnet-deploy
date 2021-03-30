#!/bin/sh

moniker=$1
gas_price=$2
version=$3

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
networkType=mainnet/deploy-config
configUrl=https://raw.githubusercontent.com/barkisnet/barkisnet-deploy/master

mkdir bin/$version -p

wget $configUrl/$networkType/binary/$version/barkisd -O bin/$version/barkisd
wget $configUrl/$networkType/binary/$version/barkiscli -O bin/$version/barkiscli
wget $configUrl/$networkType/genesis.json -O genesis.json
wget $configUrl/$networkType/networkConfig.json -O networkConfig.json
wget $configUrl/$networkType/barkis-validator-daemon -O barkis-validator-daemon
wget $configUrl/$networkType/barkis-validator-daemon.service -O barkis-validator-daemon.service

configFile=networkConfig.json

seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)

chmod +x bin/$version/barkisd
chmod +x bin/$version/barkiscli
chmod +x barkis-validator-daemon

sed -i -e "s@{{WORKDIR}}@$curDir@g" barkis-validator-daemon
sed -i -e "s@{{VERSION}}@$version@g" barkis-validator-daemon
sed -i -e "s@{{BARKIS_HOME}}@$nodeHome@g" barkis-validator-daemon
sed -i -e "s@{{USER_NAME}}@$username@g" barkis-validator-daemon
sed -i -e "s@{{USER_GROUP}}@$username@g" barkis-validator-daemon

sudo cp barkis-validator-daemon /etc/init.d/
sudo cp barkis-validator-daemon.service /etc/systemd/system

./bin/$version/barkisd init $moniker --home $nodeHome
cp genesis.json $nodeHome/config/genesis.json
sed -i -e "s/minimum-gas-prices = \"\"/minimum-gas-prices = \"$gas_price\"/g" $nodeHome/config/app.toml

for index in $(jq -r '.upgrade | keys | .[]' $configFile); do
    upgradeName=$(jq -r .upgrade[$index].name $configFile)
    upgradeHeight=$(jq -r .upgrade[$index].height $configFile)

    sed -i -e "s/$upgradeName = 9223372036854775807/$upgradeName = $upgradeHeight/g" $nodeHome/config/app.toml
done

sed -i -e "s/seeds = \"\"/seeds = \"$seed\"/g" $nodeHome/config/config.toml
sed -i -e "s/127.0.0.1:26657/0.0.0.0:26657/g" $nodeHome/config/config.toml
sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/g" $nodeHome/config/config.toml
sed -i -e "s/index_all_tags = false/index_all_tags = true/g" $nodeHome/config/config.toml
sed -i -e "s/timeout_commit = \"1s\"/timeout_commit = \"5s\"/g" barkisNode/config/config.toml

sudo systemctl daemon-reload

sudo systemctl start barkis-validator-daemon
