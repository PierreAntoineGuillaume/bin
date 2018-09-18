#!/bin/bash

set -euo pipefail

server_source="$1"
username_s1="$2"
password_s1="$3"

server_target="$4"
username_s2="$5"
password_s2="$6"

bases="$(./selectDatabases.sh $server_source $username_s1 $password_s1 "Select Databases to copy from $server_source to $server_target)"
file="$(./dumpAndDownload.sh $server_source $username_s1 $password_s1 $bases)"
./uploadAndAbsorb.sh $file $server_target $username_s2 $password_s2
