#!/usr/bin/bash

set -euo pipefail

source "$(dirname "$(realpath "$0")")/expect.sh"

set +e

err_counter=0

expect() {
  if do-expect "$@"; then
    printf "\e[32m✔\e[0m expectation succeed for %s\n" "$*"
  else
    ((err_counter += 1))
    printf "\e[31m✕\e[0m expectation failed for %s\n" "$*"
  fi
}

expect https://www.google.com to-be 200
expect https://www.google.com not-to-be 500

exit "$err_counter"


