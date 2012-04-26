#!/bin/bash
if [ `pgrep -f restarter.coffee` ]; then
  echo 'Restarter already running.'  
else
  echo 'Starting restarter'
  nohup coffee restarter.coffee &
fi
coffee runapp.coffee
