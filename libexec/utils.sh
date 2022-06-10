#!/bin/sh

#
# Posix Utils Library

#######################################
# has alias, command or function
# Arguments:
#   1   alias, command or function name
# Returns:
#   1   parameter null or not set
#######################################
has() { command -v "${1?}" >/dev/null; }

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
