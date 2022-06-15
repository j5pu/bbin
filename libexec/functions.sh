#!/bin/sh

#
# Posix Paths ($PATH, $MANPATH, $INFOPATH) Helpers

# TODO: añadir el paths.d, completions ?

#######################################
# add/prepend directory to variable (PATH, MANPATH, etc.) removing previous entries
# Globals:
#   PATH
# Arguments:
#   1   directory to add
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_add() {
  path_pop "${1?}" "${2-}"
  _path_add_value="$(eval printf %s "\$${2:-PATH}")"
  _path_add_value="${_path_add_value:+:${_path_add_value}}"
  [ "${2:-PATH}" != "MANPATH" ] || [ "${_path_add_value-}" ] || _path_add_value=":"
  eval "export ${2:-PATH}=${1}${_path_add_value}"
  unset _path_add_value
}

#######################################
# add/prepend directory to variable (PATH, MANPATH, etc.) removing previous entries if directory exists
# Arguments:
#   1   directory to add
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_add_exist() { path_pop "${1?}" "${2-}"; [ ! -d "$1" ] || path_add "$1" "${2-}"; }

#######################################
# add/prepend dir/sbin:dir/bin:dir/libexec, dir/share/info and dir/share/man removing previous entries if exist
# Globals:
#   PATH
# Arguments:
#   1   directory
# Returns:
#   1   parameter null or not set
#######################################
path_add_exist_all() {
  for _path_add_exist_all in libexec bin sbin; do
    path_add_exist "${1?}/${_path_add_exist_all}"
  done
  path_add_exist "${1?}/share/man" MANPATH
  path_add_exist "${1?}/share/info" INFOPATH
  unset _path_add_exist_all
}

#######################################
# append directory to variable (PATH, MANPATH, etc.) removing previous entry
# Arguments:
#   1   directory to append
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_append() {
  path_pop "${1?}" "${2-}"
  _path_append_value="$(eval printf %s "\$${2:-PATH}")"
  if [ "${2:-PATH}" = "MANPATH" ]; then
    _path_append_last=":"
  elif [ "${_path_append_value-}" ]; then
    _path_append_first=":"
  fi
  eval "export ${2:-PATH}=${_path_append_value}${_path_append_first-}${1}${_path_append_last-}"
  unset _path_append_first _path_append_last _path_append_value
}

#######################################
# append directory to variable (PATH, MANPATH, etc.) removing previous entry
# Arguments:
#   1   directory to append
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_append_exist() { path_pop "${1?}" "${2-}"; [ ! -d "$1" ] || path_append "$1" "${2-}"; }

#######################################
# remove duplicates from variable (PATH, MANPATH, etc.)
# Arguments:
#   1   variable name (default: PATH)
#######################################
path_dedup() {
  [ "${1:-PATH}" = "MANPATH" ] || _path_dedup_strip=":"
  eval "export ${1:-PATH}=$(eval printf %s "\$${1:-PATH}" | awk -v RS=: -v ORS=: '!arr[$0]++' | \
    sed "s/${_path_dedup_strip-}$//")"
  unset _path_dedup_strip
}

#######################################
# is directory in variable (PATH, MANPATH, etc)
# Globals:
#   PATH
# Arguments:
#   1   directory to check
#   2   variable name (default: PATH)
# Returns:
#   0 if directory in $PATH
#   1 if directory not in $PATH, parameter null or parameter not set
#######################################
path_in() {
  [ "${2:-PATH}" = "MANPATH" ] || _path_in_add=":"
  case ":$(eval printf %s "\$${2:-PATH}")${_path_in_add-}" in
    *:"${1?}":*) unset _path_in_add; return 0 ;;
    *) unset _path_in_add; return 1 ;;
  esac
}

#######################################
# removes directory from variable (PATH, MANPATH, etc.)
# Globals:
#   PATH
# Arguments:
#   1   directory to remove
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_pop() {
  [ "${2:-PATH}" = "MANPATH" ] || _path_pop_strip=":"
  eval "export ${2:-PATH}=$(eval printf %s "\$${2:-PATH}" | sed 's/:$//' | tr ':' '\n' | \
    grep -v "^${1}$" | tr '\n' ':' | sed "s/${_path_pop_strip-}$//")"
  unset _path_pop_strip
}
