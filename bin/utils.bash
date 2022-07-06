#!/usr/bin/env bash

#
# Utils Library for Bash

. utils.sh

export_funcs_path "$(command -v utils.sh)"

# Shared array to copy array used by cparray(), getkey(), getvalue() and inarray()
#
declare -Axg _ARRAY

#######################################
# copy array name to _ARRAY
# Globals:
#   _ARRAY
# Arguments:
#   [array]     array name (default: COMP_WORDS)
# Returns:
#   1 if invalid array name or type
#######################################
cparray() {
  local declare
  if declare="$(declare -p "${1:-COMP_WORDS}" 2>&1)"; then
    [[ "${declare}" =~ "declare "-[a,A] ]] || { >&2 echo "cparray: undefined array: ${declare}"; return 1; }
    eval "_ARRAY=$(cut -d '=' -f 2- <<< "${declare}")"
  else
    >&2 echo "cparray: ${declare}"
    return 1
  fi
}

#######################################
# check if value in array exists and return index
# Globals:
#   _ARRAY
# Arguments:
#   value       the value to search
#   [array]     array name (default: COMP_WORDS)
# Returns:
#   1 if value not in array, or invalid array
#######################################
getkey() {
  local index
  cparray "${2-}" || return 1
  for index in "${!_ARRAY[@]}"; do
    [ "${1?}" != "${_ARRAY[${index}]}" ] || { printf '%s' "${index}"; return; }
  done
  >&2 echo "getkey: Value: '$1', not in Array: '${2:-COMP_WORDS}'"
}

#######################################
# check if key in array and shows value or nothing with no errors (former name: default)
# Globals:
#   _ARRAY
# Arguments:
#   key         the value to search
#   [array]     array name (default: COMP_WORDS)
# Returns:
#   1 if invalid array
#######################################
getvalue() {
  cparray "${2-}" || return 1
  printf '%s' "${_ARRAY["${1?}"]}" 2>/dev/null || true
}

#######################################
# check if value in array exists
# Globals:
#   _ARRAY
# Arguments:
#   value       the value to search
#   [array]     array name (default: COMP_WORDS)
# Returns:
#   1 if value not in array, or invalid array
#######################################
inarray() {
  getkey "$@" >/dev/null
}

export_funcs_path "${BASH_SOURCE[0]}"
