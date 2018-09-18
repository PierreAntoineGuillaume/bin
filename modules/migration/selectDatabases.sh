#!/bin/bash

DIALOG=${DIALOG=dialog}

set -euo pipefail
temporary_file=$(mktemp)

cleanup(){
    rm -f $temporary_file
}

trap cleanup EXIT

target="$1"
username="$2"
password="$3"
message="$4"

db=($(./showDatabases.sh $target $username $password))
options=$(printf '%s\n' "${db[@]}" | awk '{ print NR " " $0 " OFF" }')

dialog --keep-tite --title "$message" --checklist "Selectionnez avec espace" 30 60 15 ${options[@]} 2> $temporary_file

results_indexes=($(cat $temporary_file))
results=();

for i in "${results_indexes[@]}"
do
    val=$(($i -1))
    results+=("${db[$val]}")
done


echo "${results[@]}"


