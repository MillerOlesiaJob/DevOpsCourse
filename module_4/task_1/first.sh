#!/bin/bash

threshold=10

if [ $# -eq 1 ]; then
  threshold=$1
fi

while true
do
  # Get the free space of the root filesystem in gigabytes
  free_space=$(df -h / | awk 'NR==2 {print $4}')

  echo 'Free space' $free_space

  # Check if the free space is below the threshold
  if [ "$(expr "$free_space" '<' "$threshold")" -eq 1 ]
    then
      echo "Warning: free space is below threshold"
    else
      echo "You have enough free spase"
    fi

    sleep 5
  done


