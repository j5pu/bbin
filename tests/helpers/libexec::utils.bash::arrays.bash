# shellcheck shell=bash

#
# setup for for cparray(), getkey(), getvalue() and inarray()

#######################################
# setup for for cparray(), getkey(), getvalue() and inarray()
# Globals:
#   ARRAY
#   ASSOCIATED
#   VARIABLE
# Arguments:
#  None
#######################################
# bashsupport disable=BP2001
setup() {
  . utils.bash
  # Arrays exported in setup_file are not seen in functions
  declare -Agx ASSOCIATED=(["key1"]=foo ["key2"]=bar)
  declare -gx ARRAY=(foo boo bar)
  declare -gx VARIABLE=1
}
