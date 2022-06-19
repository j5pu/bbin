# shellcheck shell=bash

cd "$(dirname "${BASH_SOURCE[0]}")"/../.. || return
load tests/helpers/helper_setup.bash

#######################################
# run the container
# Globals:
#   DESCRIPTION
#   PWD
# Arguments:
#  None
#######################################
container() {
  bats::array
  path_add_all "/${BATS_BASENAME}"
  >&3 echo "$PATH"
  >&3 echo "$MANPATH"
  >&3 echo "$INFOPATH"
  return
  local c=() env=(-e PATH="${BATS_BASENAME}/bin") helper=("/rc/tests/fixtures/${BATS_ARRAY[3]}.sh") shell=( "${DESCRIPTION[4]-}" )
  if [ "${DESCRIPTION[3]}" = '-c' ]; then
    c=( "${DESCRIPTION[3]}" )
    helper=( "/rc/tests/fixtures/${DESCRIPTION[4]}.sh${DESCRIPTION[5]:+ ${DESCRIPTION[5]}}" )
    shell=()
  fi
  docker run -i --rm -v "${BATS_TOP}:/${BATS_BASENAME}" \
    "${DESCRIPTION[0]}" "${DESCRIPTION[2]}" "${c[@]}" "${helper[@]}" "${shell[@]}"

}

#######################################
# evaluates the output
# Globals:
#   BATS_TEST_DESCRIPTION
#   DESCRIPTION
# Arguments:
#  None
#######################################
shell() {
  ! isaction || skip

  read -r -a DESCRIPTION <<< "${BATS_TEST_DESCRIPTION}"
  run container "$@"
  return
  assert_line --partial "${DESCRIPTION[1]}"
}
