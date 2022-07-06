#!/bin/sh

#
# System and users profile for bash, busybox, dash, ksh, sh and zsh (/etc/profile and /etc/zprofile).

# TODO: añadir el paths.d, completions ?

# Bbin default instalation directory (can only be changed to test $BBIN_DEFAULT_SOURCED and $BBIN_DEVELOPMENT_SOURCED)
#
: "${BBIN_PREFIX_DEFAULT=/opt/brew}"; export BBIN_PREFIX_DEFAULT

# Bbin running prefix
#
: "${BBIN_PREFIX=${BBIN_PREFIX_DEFAULT}}"; export BBIN_PREFIX

# Bbin system wide default profile
#
export BBIN_PROFILE_DEFAULT="${BBIN_PREFIX_DEFAULT}/bin/profile.sh"

# Bbin system wide profile
#
export BBIN_PROFILE="${BBIN_PREFIX}/bin/profile.sh"

# Default Bbin install already sourced
#
: "${BBIN_DEFAULT_SOURCED=0}"

# Development Bbin already sourced
#
: "${BBIN_DEVELOPMENT_SOURCED=0}"

# 1 if $BBIN_PREFIX different from $BBIN_PREFIX
#
export BBIN_DEVELOPMENT

# Bbin Debug to test number of times is sourced
#
: "${BBIN_DEBUG=0}"; export BBIN_DEBUG

# Homebrew etc/profile.d sourced
#
: "${BREW_PROFILE_D_SOURCED=0}"

# Public Configuration Files Repository Submodule, i.e.: can be defined with Global Variables)
#
export CONFIG="${BBIN_PREFIX}/config"
export XDG_CONFIG_HOME="${CONFIG}"

test $BBIN_DEBUG -eq 0 || [ ! "${BASH_SOURCE-}" ] || caller

if [ "${BBIN_PREFIX_DEFAULT}" = "${BBIN_PREFIX}" ]; then
  BBIN_DEVELOPMENT=0
  test $BBIN_DEFAULT_SOURCED -eq 0 || return 0
  BBIN_DEFAULT_SOURCED=1
else
  BBIN_DEVELOPMENT=1
  test $BBIN_DEVELOPMENT_SOURCED -eq 0 || return 0
  BBIN_DEVELOPMENT_SOURCED=1
fi

test -f "${BBIN_PROFILE}" || { >&2 echo "${BBIN_PROFILE}: No such file"; return 1 2>/dev/null || exit; }

#######################################
# export all functions
# Arguments:
#  None
#######################################
export_funcs_all() {
  [ "${BASH_VERSION-}" ] || return 0
  # shellcheck disable=SC2046,SC3045,SC3044
  export -f $(compgen -A function)
}

#######################################
# export file or files functions
# Arguments:
#  Files or Directories to search for functions
#######################################
export_funcs_path() {
  [ "${BASH_VERSION-}" ] || return 0
  # shellcheck disable=SC2046,SC3045
  export -f $("${BBIN_PREFIX}/bin/filefuncs"  "$@")
}

#######################################
# export public functions (not starting with _)
# Arguments:
#  None
#######################################
export_funcs_public() {
  [ "${BASH_VERSION-}" ] || return 0
  # shellcheck disable=SC2046,SC3045,SC3044
  export -f $(compgen -A function | grep -v '^_')
}

#######################################
# has alias, command or function
# Arguments:
#   1   alias, command or function name
# Returns:
#   1   parameter null or not set
#######################################
has() { command -v "${1?}" >/dev/null; }

#######################################
# description
# Arguments:
#  None
# Returns:
#   $__history_prompt_rc ...
#######################################
history_prompt() {
  # shellcheck disable=SC3043
  local __history_prompt_rc=$?
  history -a; history -c; history -r; hash -r
  return $__history_prompt_rc
}

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
  path_pop "${1:-${PWD}}" "${2-}"
  _path_add_value="$(eval echo "\$${2:-PATH}")"
  _path_add_value="${_path_add_value:+:${_path_add_value}}"
  [ "${2:-PATH}" != "MANPATH" ] || [ "${_path_add_value-}" ] || _path_add_value=":"
  _path_add_real="$("${BBIN_PREFIX}/bin/pwd_p" "${1:-${PWD}}" )"
  eval "export ${2:-PATH}='${_path_add_real}${_path_add_value}'"
  unset _path_add_value _path_add_real
}

#######################################
# add/prepend dir/sbin:dir/bin:dir/libexec, dir/share/info and dir/share/man removing previous entries
# Globals:
#   PATH
# Arguments:
#   1   directory
# Returns:
#   1   parameter null or not set
#######################################
path_add_all() {
  for _path_add_all in libexec bin sbin; do
    path_add "${1:-${PWD}}/${_path_add_all}"
  done
  path_add "${1:-${PWD}}/share/man" MANPATH
  path_add "${1:-${PWD}}/share/info" INFOPATH
  unset _path_add_all
}

#######################################
# add/prepend directory to variable (PATH, MANPATH, etc.) removing previous entries if directory exists
# Arguments:
#   1   directory to add
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_add_exist() { path_pop "${1:-${PWD}}" "${2-}"; [ ! -d "${1:-${PWD}}" ] || path_add "${1:-${PWD}}" "${2-}"; }

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
    path_add_exist "${1:-${PWD}}/${_path_add_exist_all}"
  done
  path_add_exist "${1:-${PWD}}/share/man" MANPATH
  path_add_exist "${1:-${PWD}}/share/info" INFOPATH
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
  path_pop "${1:-${PWD}}" "${2-}"
  _path_append_value="$(eval echo "\$${2:-PATH}")"
  if [ "${2:-PATH}" = "MANPATH" ]; then
    _path_append_last=":"
  elif [ "${_path_append_value-}" ]; then
    _path_append_first=":"
  fi
  _path_append_real="$("${BBIN_PREFIX}/bin/pwd_p" "${1:-${PWD}}")"
  eval "export ${2:-PATH}='${_path_append_value}${_path_append_first-}${_path_append_real}${_path_append_last-}'"
  unset _path_append_first _path_append_last _path_append_real _path_append_value
}

#######################################
# append directory to variable (PATH, MANPATH, etc.) removing previous entry
# Arguments:
#   1   directory to append
#   2   variable name (default: PATH)
# Returns:
#   1   parameter null or not set
#######################################
path_append_exist() { path_pop "${1:-${PWD}}" "${2-}"; [ ! -d "${1:-${PWD}}" ] || path_append "${1:-${PWD}}" "${2-}"; }

#######################################
# remove duplicates from variable (PATH, MANPATH, etc.)
# Arguments:
#   1   variable name (default: PATH)
#######################################
path_dedup() {
  [ "${1:-PATH}" = "MANPATH" ] || _path_dedup_strip=":"
  _path_dedup_value="$(eval echo "\$${1:-PATH}" |  tr ':' '\n' | awk '!NF || !seen[$0]++' | \
    sed -n "H;\${x;s|\n|:|g;s|^:||;s|${_path_dedup_strip-}$||;p;}")"
  [ "${_path_dedup_value}" != ":" ] || _path_dedup_value=""
  eval "export ${1:-PATH}='${_path_dedup_value}'"
  unset _path_dedup_strip _path_dedup_value
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
  _path_in_real="$("${BBIN_PREFIX}/bin/pwd_p" "${1:-${PWD}}")"
  case ":$(eval echo "\$${2:-PATH}")${_path_in_add-}" in
    *:"${_path_in_real}":*) unset _path_in_add _path_in_real; return 0 ;;
    *) unset _path_in_add _path_in_real; return 1 ;;
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
  _path_pop_real="$("${BBIN_PREFIX}/bin/pwd_p" "${1:-${PWD}}")"
  _path_pop_value="$(eval echo "\$${2:-PATH}" | sed 's/:$//' | tr ':' '\n' | \
    grep -v "^${_path_pop_real}$" | tr '\n' ':' | sed "s|${_path_pop_strip-}$||")"
  [ "${_path_pop_value}" != ":" ] || _path_pop_value=""
  eval "export ${2:-PATH}='${_path_pop_value}'"
  unset _path_pop_real _path_pop_strip _path_pop_value
}

#######################################
# rebash
# Globals:
#   PATH
#######################################
rebash() {
  unset BASH_COMPLETION_VERSINFO BREW_PROFILE_D_SOURCED
  ! test -f "${BBIN_PROFILE_DEFAULT}" || { unset BBIN_DEFAULT_SOURCED; . "${BBIN_PROFILE_DEFAULT}"; }
  test $BBIN_DEVELOPMENT -eq 0 || { unset BBIN_DEVELOPMENT_SOURCED; . "${BBIN_PROFILE}"; }
}

#######################################
# sources all files in the first level of a directory, including hidden files
# Arguments:
#  directory    path of directory to source (default: cwd).
#######################################
source_dir() {
  if dir-has-files "${1:-.}"; then
    for _source_dir_file in "${1:-.}"/*; do
      ! test -f "${_source_dir_file}" || . "${_source_dir_file}"
    done
    unset _source_dir_file
  fi
}

#######################################
# set shell option if available
# Arguments:
#  directory    path of directory to source (default: cwd).
#######################################
_shell_opt() {
  for arg; do
    if set -o | grep -q "${arg}"; then
      if [ "${SH}" =  "posix-ksh" ]; then
        set -o"${arg}"
      else
        set -o "${arg}"
      fi
    fi
  done
}

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
path_add_exist_all "${BBIN_PREFIX}"
export_funcs_path "${BBIN_PROFILE}"
. shell.sh

source_dir "${BBIN_PREFIX}/etc/profile.d/constants"
source_dir "${BBIN_PREFIX}/etc/profile.d"
source_dir "${BBIN_PREFIX}/etc/profile.d/${SH}"
[ "${SH}" = "${SHELL_HOOK:-${SH}}" ] || source_dir "${BBIN_PREFIX}/etc/profile.d/${SHELL_HOOK}"

if [ "${HOMEBREW_PREFIX-}" != "${BBIN_PREFIX}" ] && test $BREW_PROFILE_D_SOURCED -eq 0; then
  BREW_PROFILE_D_SOURCED=1; source_dir "${HOMEBREW_PREFIX}/etc/profile.d"
fi

if [ ! "${PS1-}" ]; then
  _shell_opt errtrace functrace
  return
fi

_shell_opt autocd cdablevars emacs histappend histexpand nocaseglob nocasematch

source_dir "${BBIN_PREFIX}/etc/rc.d"
source_dir "${BBIN_PREFIX}/etc/rc.d/${SH}"
[ "${SH}" = "${SHELL_HOOK:-${SH}}" ] || source_dir "${BBIN_PREFIX}/etc/rc.d/${SHELL_HOOK}"

export PROMPT_COMMAND="history_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

unset -f _shell_opt
