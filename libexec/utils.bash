#!/usr/bin/env bash

#
# Bash Utils Library

. utils.sh

[ "${BASH_VERSION-}" ] || return 0 2>/dev/null || exit 0

#######################################
# export all functions
# Arguments:
#  None
#######################################
export_funcs_all() {
  # shellcheck disable=SC2046
  export -f $(compgen -A function)
}

#######################################
# export public functions (not starting with _)
# Arguments:
#  None
#######################################
export_funcs_public() {
  # shellcheck disable=SC2046
  export -f $(compgen -A function | grep -v '^_')
}

#######################################
# export file or files functions
# Arguments:
#  Files or Directories to search for functions
#######################################
export_funcs_path() {
  # shellcheck disable=SC2046
  export -f $(filefuncs "$@")
}
