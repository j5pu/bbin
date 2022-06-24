# shellcheck shell=bash

# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
# CTRL+R -> history search, and CTRL+S -> history search backward
# $ sudo (I want know completions .. CTRL+A CTRL+R CTRL+Y ... CTRL+R
stty -ixon

# https://zwischenzugs.com/2019/04/03/eight-obscure-bash-options-you-might-want-to-know-about/ (extglob screws)
shopt -s autocd cdable_vars checkwinsize dotglob execfail nocaseglob nocasematch

source_dir "${BBIN_PREFIX}/etc/bash_completion.d"
