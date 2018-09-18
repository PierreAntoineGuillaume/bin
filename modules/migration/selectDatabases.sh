#!/bin/bash

DIALOG=${DIALOG=dialog}

set -euo pipefail

file="$(mktemp)"

target="$1"
username="$2"
password="$3"
message="$4"

db=($(./showDatabases.sh $target $username $password))
options=$(printf '%s\n' "${db[@]}" | awk '{ print NR " " $0 " OFF" }')

dialog --keep-tite --title "$message" --checklist "Selectionnez avec espace" 30 60 15 ${options[@]} 2> $file
mapF () { printf "${db[$1]}"; } 
mapfile -t array -C "mapF" < $file
echo "${array[@]}" >> /dev/stderr
