#!/bin/bash -l

set -euo pipefail

target="$1"
username="$2"
password="$3"

ssh "$target" mysql -N --user="$username" --password="$password" <<< 'show databases';
