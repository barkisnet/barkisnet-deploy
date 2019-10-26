#!/bin/bash

ps -aux  | grep barkisd | grep -v grep | awk '{print $2}' | xargs kill -9
