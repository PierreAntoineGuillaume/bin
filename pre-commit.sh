#!/usr/bin/env bash

set -euo pipefail

dirty_stash_list=()

trap cleanup_dirty_stash_list EXIT ERR

get_stash_id() {
  git rev-parse -q --verify refs/stash || true
}

cleanup_dirty_stash_list () {
  echo "Cleaning up"
  for id in "${dirty_stash_list[@]}"; do
    git stash pop "${id}"  || true
  done
  dirty_stash_list=()
}

qad_this() {
  if qad ci; then
    git add -A
  else
    git restore .
    >2 echo "qad ci failed"
  fi
}

stash_unstaged_and_fill_dirty_stash_list() {
  staged_stash_id=
  unstaged_stash_id=
  ignored_stash_id=$(get_stash_id)
  git stash push --staged || true
  staged_stash_id=$(get_stash_id)

  if [ "${staged_stash_id}" = "${ignored_stash_id}" ]; then
    # stash already existed, it is not relative to staged files
    staged_stash_id=
  fi

  git stash push --include-untracked || true

  unstaged_stash_id=$(get_stash_id)

  if [ "${staged_stash_id}" = "${unstaged_stash_id}" ]; then
    # stash already existed so no stash were created
    unstaged_stash_id=
  fi

  if [ -n "${staged_stash_id}" ] && [ -n "${unstaged_stash_id}" ]; then
    dirty_stash_list=("stash@{0}")
    git stash pop "stash@{1}"
    git add -A
  elif [ -n "${staged_stash_id}" ]; then
    git stash pop "stash@{0}"
    git add -A
  elif [ -n "${unstaged_stash_id}" ]; then
    dirty_stash_list=("stash@{0}")
  fi
}

stash_unstaged_and_fill_dirty_stash_list
qad_this
cleanup_dirty_stash_list
