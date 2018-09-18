#!/bin/bash

set -euo pipefail

targetFilename="$1"
targetServer="$2"
username="$3"
password="$4"

SSH_SENT="mysql -h localhost --user=$username --password=$password < $targetFilename"

echo "Copying ..."
scp $targetFilename $targetServer:$targetFilename
echo "Absorbing ..."
ssh $targetServer $SSH_SENT
echo "Cleaning ..."
ssh $targetServer rm $targetFilename
