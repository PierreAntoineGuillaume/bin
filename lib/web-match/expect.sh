#!/usr/bin/env bash

set -euo pipefail

function do-expect () {
  page=${1}
  shift
  code=
  not_code=
  connection=
  args=()
  while (( $# )); do
    case "$1" in
      to-be)
          code=$2
          shift
      ;;
      to-not-be)
          not_code=$2
          shift
          ;;
      with-connection)
          connection=$2
          shift
      ;;
      *)
        args+=("$1")
      ;;
    esac
    shift
  done
  set -- "${args[@]}"

  CURL=${CURL:-curl}

  if [ -n "$connection" ]; then
      parse-header "$code" "$not_code" < <($CURL --no-progress-meter --head "$page" --cookie "PHPSESSID=$connection")
  else
    parse-header "$code" "$not_code" < <($CURL --no-progress-meter --head "$page")
  fi

  return $?
}

function parse-header() {
  expectedCode=$1
  expectedNotCode=$2
  actualCode=$(awk 'NR==1 { print $2 }')

  if [ -n "$expectedCode" ] && [ "$expectedCode" != "$actualCode" ]; then
    return 1;
  fi

  if [ -n "$expectedNotCode" ] && [ "$expectedNotCode" == "$actualCode" ]; then
    return 1;
  fi
  return 0
}
