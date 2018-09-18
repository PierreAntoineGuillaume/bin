#!/bin/bash

DIALOG=${DIALOG=dialog}

set -euo pipefail

result=$(mktemp)
expectFile=$(mktemp)

dialog --keep-tite --title "Configurez l'accès au nouveau server" \
    --form "" 30 60 16 \
    "Server host"  1 1 "" 1 25 25 30 \
    "Server alias" 2 1 "" 2 25 25 30 \
    "username"     3 1 "it-siweb" 3 25 25 30 \
    "password"     4 1 "" 4 25 25 30 \
    2> $result

#IFS=$'\n'i

mapfile -t array < $result

serverhost="${array[0]}"
serveralias="${array[1]}"
username="${array[2]}"
password="${array[3]}"

config="$(augtool match /files${HOME}/.ssh/config/*/hostname $serverhost)"


array_contains () {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}


if [ -z "$config" ]; then
    while true; do
        read -p "Install SSH configuration for host $serverhost with alias $serveralias ? Y/N " yn
        case $yn in
            [YyOo]* ) break;;
            [Nn]* ) exit 1;;
            * ) echo "Answer Y / N"
        esac
    done

    printf 'Host %s\n\tuser %s\n\thostname %s\n' "$serveralias" "$username" "$serverhost" >> ~/.ssh/config
else
    ref="$(dirname $config)"
    echo "Printing $ref"
    currentAlias="$(augtool print $ref | head -n 1)"
    currentAlias="${currentAlias%\"}"
    currentAlias=("${currentAlias#*\"}")
    if ! array_contains "$serveralias" "${currentAlias[@]}"; then
        currentAlias+=("$serveralias")
        augtool set "$ref/host ${currentAlias[@]}"
        echo "Aliases for $serverhost updated to ${currentAlias[@]}"
    else
        echo "Alias already known"
    fi
fi

exit




echo "#!/usr/bin/expect -f
spawn ssh-copy-id $serveralias
expect \"password:\"
send \"$password\"
expect eof" > $expectFile

$expectFile

ssh $serveralias
