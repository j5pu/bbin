# shellcheck shell=zsh

#######################################
# select/search snippets at the current line
# https://github.com/knqyf263/pet#select-snippets-at-the-current-line-like-c-r
# Globals:
#   BUFFER
#   READLINE_LINE
#   READLINE_POINT
# Arguments:
#  None
#######################################
pet_select() {
  BUFFER=$(pet search --query "${LBUFFER}")
  CURSOR=$#BUFFER
  zle redisplay
}

zle -N pet_select
stty -ixon
bindkey '^s' pet_select

#######################################
# save previous command to pet
# Arguments:
#  None
#######################################
prev() {
  PREV="$(fc -lrn | head -n 1)"
  sh -c "pet new "$(printf %q "${PREV}")
}
