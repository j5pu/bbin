# shellcheck shell=bash

export BATS_FILE_PATH="${PATH}"

#######################################
# has colon at the end
# Globals:
#   PATH
# Arguments:
#  1  Variable name
#######################################
assert_colon() { assert_equal "${!1: -1}" ":"; }

#######################################
# assert $MANPATH is equal to arg and colon at the end
# Globals:
#   PATH
# Arguments:
#   1  Value to check
#######################################
assert_manpath() { assert_equal "${MANPATH}" "$1"; assert_colon MANPATH; }

#######################################
# assert $PATH is equal to arg and check not colon at the end
# Globals:
#   PATH
# Arguments:
#   1  Value to check
#######################################
assert_path() { assert_equal "${PATH}" "$1";  refute_colon PATH; }

#######################################
# not colon at the end
# Globals:
#   PATH
# Arguments:
#  1  Variable name
#######################################
refute_colon() { refute [ "${!1: -1}" = ":" ]; }

export_funcs_path "${BASH_SOURCE[0]}"
