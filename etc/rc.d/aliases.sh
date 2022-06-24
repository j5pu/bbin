# shellcheck shell=sh

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'

! has grc || GRC_ALIASES=true . "${HOMEBREW_PREFIX}/etc/grc.sh"
