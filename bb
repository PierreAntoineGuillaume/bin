#!/bin/bash
    
set -euo pipefail

SOFT="$(basename $0)"


while getopts ":t:" option
do
    case "$option" in
    t)
        echo "option test ok"
        echo "$OPTARG"
        ;;
    esac
done
