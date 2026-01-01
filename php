#!/bin/env bash

git_root=$(git rev-parse --show-toplevel)
php_version_file=${git_root}/.php-version

if test -f "${php_version_file}"; then
  binary=$(cat "${php_version_file}")
  exec "$binary" "$@"
fi


composer_path="${git_root}/composer.json"

version=$(jq -r '
  [
    .config.platform.php,
    .require.php
  ]
  | map(select(. != null))
  | map(
      capture("(?<major>[0-9]+)\\.(?<minor>[0-9]+)") 
      | "\(.major).\(.minor)"
    )
  | min
' "${composer_path}")

exec php${version} "$@"
