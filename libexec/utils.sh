#!/bin/sh

#
# Posix Utils Library

#######################################
# change to git repository top path
# Arguments:
#  None
# Returns:
#   1 if not git repository
#######################################
top_cd() {
  # Git Repository Top Path if exist
  #
  TOP_CD=""
  if TOP_CD="$(git rev-parse --show-toplevel)"; then
    cd "${TOP_CD}" || return 1
    return
  fi
  return 1
}

#######################################
# change to git repository top path and exit if not git repository
# Arguments:
#  None
# Returns:
#   1 if not git repository (exit)
#######################################
top_cd_exit() { top_cd || exit; }
