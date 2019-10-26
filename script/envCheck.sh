#!/bin/bash

jqPath=$(which jq)
if [ -z "$jqPath" ]
then
      sudo apt-get install jq -y
fi
