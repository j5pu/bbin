#!/bin/sh

#
# Change Directory Posix Utils Library

#######################################
# change to git repository top path
# Arguments:
#  None
# Returns:
#   1 if not git repository
#######################################
cd_top() {
  # Git Repository Top Path if exist
  #
  CD_TOP=""
  if CD_TOP="$(git rev-parse --show-toplevel 2>&1)"; then
    cd "${CD_TOP}" || return 1
    return
  else
    >&2 echo "cd_top: ${PWD}: ${CD_TOP}"
    CD_TOP=""
    return 1
  fi
}

#######################################
# change to git repository top path and exit if not git repository
# Arguments:
#  None
# Returns:
#   1 if not git repository (exit)
#######################################
cd_top_exit() { cd_top || exit; }
