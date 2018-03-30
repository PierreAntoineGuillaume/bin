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
SWGS[danone]='https://admin-danone.siwipo.fr'
SWGS[pepsi]='https://admin.siwipo.fr'
SWGS[demov2]='https://admin-demo.siwipo.fr'
SWGS[ticket]='http://espace-client.siweb.fr/espace-client/support-technique/tickets-en-cours'
SWGS[square]='https://admin-square.siwipo.fr'



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
                    echo "$(main convert $2)"
                    navigator "$(main convert $2)";
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

    
