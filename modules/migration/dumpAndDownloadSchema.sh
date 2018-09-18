#!/bin/bash

set -euo pipefail

targetServer="$1"
sqlUsername="$2"
sqlPassword="$3"
shift 3
targetSchemas="$@"
targetFilename="/tmp/autodump_${targetSchemas// /_}_$$"
SSH_SENT="mysqldump -h localhost --user=$sqlUsername --password=$sqlPassword --opt --routines --databases $targetSchemas > $targetFilename"

echo "Dumping ..."
ssh $targetServer $SSH_SENT
echo "Copying ..."
scp $targetServer:$targetFilename $targetFilename
echo "Cleaning ..."
ssh $targetServer rm $targetFilename
