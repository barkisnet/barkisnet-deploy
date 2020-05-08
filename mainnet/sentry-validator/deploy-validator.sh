#!/bin/sh

moniker=$1
gas_price=$2
version=$3
sentry_node=$4

if [ -z "$moniker" ] || [ -z "$gas_price" ] || [ -z "$sentry_node" ]
then
  echo "Wrong usage!! Correct usage: sh deploy.sh [moniker] [mini_gas_price] [sentry_node]"
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
networkType=barkisnet-mainnet
configUrl=https://raw.githubusercontent.com/barkisnet/barkisnet-binary/master

mkdir bin/$version -p

wget $configUrl/$networkType/binary/$version/barkisd -O bin/$version/barkisd
wget $configUrl/$networkType/binary/$version/barkiscli -O bin/$version/barkiscli
wget $configUrl/$networkType/genesis.json -O genesis.json
wget $configUrl/$networkType/barkis-validator-daemon -O barkis-validator-daemon
wget $configUrl/$networkType/barkis-validator-daemon.service -O barkis-validator-daemon.service

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

sed -i -e "s/persistent_peers = \"\"/persistent_peers = \"$sentry_node\"/g" $nodeHome/config/config.toml
sed -i -e "s/timeout_commit = \"1s\"/timeout_commit = \"5s\"/g" barkisNode/config/config.toml

# Deny inbond peer connection
sed -i -e "s/0.0.0.0:26656/127.0.0.1:26656/g" $nodeHome/config/config.toml
# Shutdown Peer exchange service
sed -i -e "s/pex = true/pex = false/g" $nodeHome/config/config.toml

sudo systemctl daemon-reload

sudo systemctl start barkis-validator-daemon
