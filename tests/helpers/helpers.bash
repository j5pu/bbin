# shellcheck shell=bash

#######################################
# skip test if var is not defined
# Globals:
#   var
# Arguments:
#  None
#######################################
skip::if::not::command() {
  has "$1" || skip "${1}: not installed"
}

#######################################
# skip test if var is not defined
# Globals:
#   var
# Arguments:
#  None
#######################################
skip::if::not::var() {
  [ "${!1-}" ] || skip "Missing: ${1}"
}

export_funcs_path "${BASH_SOURCE[0]}"
