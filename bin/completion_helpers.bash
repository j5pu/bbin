# shellcheck shell=bash

# Default help options for git completions
#
export _COMPLETION_DEFAULT_HELPS_GIT=(-h --help)

# Default help options for completions
#
export _COMPLETION_DEFAULT_HELPS=("${_COMPLETION_DEFAULT_HELPS_GIT[@]}" help)

#######################################
# completions for commands with one command
# default: helps only from $_COMPLETION_DEFAULT_HELPS_GIT (for git- or "git" command) or $_COMPLETION_DEFAULT_HELPS
# Globals:
#   COMPREPLY
# Arguments:
#   -d    show dirs only from _filedir from share/bash-completion/bash_completion
#   -f    show _filedir from share/bash-completion/bash_completion
#   1     helps and/or other commands (default: -h --help help)
#######################################
_comp_one_command() {
  local args=() has_git=false help_options=() is_git_command=false show_dirs=() show_files=false

  if [ "${COMP_WORDS[0]%%-*}" = "git" ]; then
    has_git=true
    help_options=("${_COMPLETION_DEFAULT_HELPS_GIT[@]}")
    if [ "${COMP_WORDS[0]}" = "git" ]; then
      is_git_command=true
    else
      local __git_cmd_idx=0
    fi
  else
    help_options=("${_COMPLETION_DEFAULT_HELPS[@]}")
  fi

  for arg; do
    shift
    case "$arg" in
      -d) show_dirs+=("${arg}"); show_files=true;;
      -f) show_files=true;;
      *)
        ! inargs "${arg}" "${help_options[@]}" || help_options=()
        set -- "$@" "$arg" ;;
    esac
  done

  set -- "$@" "${help_options[@]}"

  _init_completion -n :=/ || return  # sets "cur prev words cword" (share/bash-completion/bash_completion)

  # Starts in first word after command and loop until everything but last
  local c=$((__git_cmd_idx+1))
  if [ $c -eq "${cword}" ]; then
    ! $show_files || _filedir "${show_dirs[@]}" # sets COMPREPLY (share/bash-completion/bash_completion)
    # _get_comp_words_by_ref resets "$2" so $cur needs to be used
    mapfile -t args < <(compgen -W "$*" -- "${cur}")
    COMPREPLY+=("${args[@]}")
    # if "git" command continues giving completions because ___git_complete wrapper complete -o bashdefault
    if $is_git_command && inargs "${cur}" "${COMPREPLY[@]}"; then
        COMPREPLY=()
    fi
  fi
}
