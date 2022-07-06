# shellcheck shell=sh

[ "${SHELL_HOOK-}" ] || return 0

# checks interactive and has __fzf_select_ for non-interactive
! test -e "${HOMEBREW_PREFIX}/opt/fzf/shell" || for _hook_sh in completion key-bindings; do
  . "${HOMEBREW_PREFIX}/opt/fzf/shell/${_hook_sh}.${SHELL_HOOK}"
done

unset _hook_sh
