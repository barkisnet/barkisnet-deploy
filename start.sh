#!/bin/bash

barkisd=$HOME/barkisd
barkiscli=$HOME/barkiscli

home=$HOME/.barkisd
gas_price=$1

nohup $barkisd start --minimum-gas-prices $gas_price > barkis.log 2>&1 &
