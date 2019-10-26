#!/bin/bash

command=$1
configFile=$2

if [ -z "$command" ] || [ -z "$configFile" ]
then
	echo "Wrong command!!"
  	echo "./barkis.sh {deploy|start|stop|upgrade|changeGasPrice} {config file}"
	exit 0
fi

username=$(jq -r .username $configFile)
ip=$(jq -r .ip $configFile)
barkisPath=$(jq -r .barkisdPath $configFile)
cert=$(jq -r .certPath $configFile)
moniker=$(jq -r .moniker $configFile)
genesis=$(jq -r .genesis $configFile)
seed=$(jq -r .seed $configFile)
persistent_peers=$(jq -r .persistent_peers $configFile)
gasPrice=$(jq -r .gasPrice $configFile)

case "$command" in
  deploy)
	scp -i $cert $barkisPath $username@$ip:~
	scp -i $cert script/envCheck.sh $username@$ip:~
	scp -i $cert $configFile $username@$ip:~/config.json
	scp -i $cert script/deploy.sh $username@$ip:~
	scp -i $cert script/start.sh $username@$ip:~

	ssh -i $cert -t $username@$ip "bash envCheck.sh"
	ssh -i $cert -t $username@$ip "bash deploy.sh config.json"
	ssh -i $cert -t $username@$ip "nohup bash start.sh $gasPrice"
	;;
  start)
	scp -i $cert script/start.sh $username@$ip:~
	ssh -i $cert -t $username@$ip "nohup bash start.sh $gasPrice"
        ;;
  stop)
	scp -i $cert script/stop.sh $username@$ip:~
	ssh -i $cert -t $username@$ip "bash stop.sh"
	;;
  upgrade)
	scp -i $cert script/start.sh $username@$ip:~
	scp -i $cert script/stop.sh $username@$ip:~
	ssh -i $cert -t $username@$ip "bash stop.sh"
	scp -i $cert $barkisPath $username@$ip:~
	ssh -i $cert -t $username@$ip "nohup bash start.sh $gasPrice"
	;;
  changeGasPrice)
	scp -i $cert script/stop.sh $username@$ip:~
	scp -i $cert script/start.sh $username@$ip:~
	ssh -i $cert -t $username@$ip "bash stop.sh"
	ssh -i $cert -t $username@$ip "nohup bash start.sh $gasPrice"
	;;
esac
