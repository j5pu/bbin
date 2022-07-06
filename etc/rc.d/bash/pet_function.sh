# shellcheck shell=bash

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
  local BUFFER
  BUFFER=$(pet search --query "$READLINE_LINE")
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}

bind -x '"\C-x\C-r": pet_select'

#######################################
# save previous command to pet
# Arguments:
#  None
#######################################
prev() {
  local PREV
  PREV="$(history | tail -n2 | head -n1 | sed 's/[0-9]* //')"
  sh -c "pet new $(printf %q "${PREV}")"
}
