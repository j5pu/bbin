# shellcheck shell=sh

[ "${SHELL_HOOK-}" ] || return 0

! has direnv || { eval "$(direnv hook "${SHELL_HOOK}")"; alias allow='direnv allow'; alias reload='direnv reload'; }
! has starship || eval "$(starship init "${SHELL_HOOK}")"
