#!/bin/sh

#
# Change Directory Posix Utils Library

# Git Repository Top Path if exist for cd_top() and cd_top_exit()
#
export GIT_TOP=""

#######################################
# change to git repository top path
# Arguments:
#  None
# Returns:
#   1 if not git repository
#######################################
cd_top() {
  if GIT_TOP="$(git rev-parse --show-toplevel 2>&1)"; then
    cd "${GIT_TOP}" || return 1
    return
  else
    >&2 echo "cd_top: ${PWD}: ${GIT_TOP}"
    GIT_TOP=""
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

#######################################
# show usage
# Arguments:
#   1
#######################################
__cmd_help() {
  >&2 cat <<EOF
usage: ${0##*/} [command...]
       . ${0##*/}.sh; ${0##*/} [function...]
       ${0##*/} [-h|--help|help]

command, builtin, function, alias exists

Arguments:
  [command...]          command, builtin and function or alias when sourced

Commands:
   -h, --help, help     display this help and exit.

Returns:
   1 if at least one of commands does not exist
EOF
}

#######################################
# command or commands exists
# Arguments:
#  command [command]    command or commands
# Returns:
#  1 if any of the command does not exist
#######################################
cmd() {
  if test $# -eq 0; then
    __cmd_help "$@"; return 1
  else
    case "$1" in
      -h|--help|help) __cmd_help; return 0 ;;
    esac
  fi

  if [ $# -eq 1 ]; then
    type "$1" >/dev/null 2>&1
  else
    tmp="$(mktemp)"
    type "$@" >/dev/null 2>"${tmp}"
    ! test -s "${tmp}" || grep -qv "not found" "${tmp}"
  fi
}
