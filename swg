#!/bin/bash
    
set -euo pipefail

SOFT="$(basename $0)"

err (){
    echo "Error $SOFT : $@"
    exit 127
}

cleanup (){
    :
}

trap cleanup EXIT


declare -A SWGS;

                        
SWGS[senlis]='http://srv24.siweb.fr/lmds'
SWGS[danone]='http://admin-danone.siwipo.fr'
SWGS[pepsi]='http://admin.siwipo.fr'
SWGS[demov2]='http://admin-demo.siwipo.fr'



main (){
    while (( "$#" ));
    do
        case "$1" in
            list)
                for K in "${!SWGS[@]}"; do echo "$K"; done
                ;;
            convert)
                if [ "${SWGS[$2]+abc}"  ];then
                    echo "${SWGS[$2]}"
                else
                    err "unknown key $2"
                fi
                shift
                ;;
            open)
                while (( "$#" -1 ))
                do
                    navigator "$($SOFT convert $2)";
                    shift
                done
            ;;
            edit)
            vim "$0"
                ;;  
            *)
                err "Unknown Option $1"
            ;;
        esac
        shift
    done
}

main $@

    
