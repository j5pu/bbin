# shellcheck shell=bash

#######################################
# evaluates the output
# Globals:
#   BATS_TEST_DESCRIPTION
#   DESCRIPTION
# Arguments:
#  None
#######################################
assert_container() {
  test "${BATS_LOCAL}" -eq 0 || skip "BATS_LOCAL is set to 1"

  bats::array

  bats_require_minimum_version 1.5.0

  if test $# -eq 1; then
    run -127 shell_container
    assert_failure
    assert_line --partial "$1"
  else
    run shell_container
    assert_success
    assert_line "${BATS_ARRAY[0]}"
  fi
}

#######################################
# run the container
# Globals:
#   DESCRIPTION
#   PWD
# Arguments:
#  None
#######################################
shell_container() {
  path_add_all "/${BATS_BASENAME}"
  PATH="/${BATS_BASENAME}/tests/fixtures/shell:${PATH}"
  local c=() env=(-e PATH="${PATH}" -e MANPATH="${MANPATH}" -e INFOPATH="${INFOPATH}")
  local helper=("/${BATS_BASENAME}/tests/fixtures/shell/${BATS_ARRAY[3]}") shell=( "${BATS_ARRAY[4]-}" )
  if [ "${BATS_ARRAY[3]}" = '-c' ]; then
    c=( "${BATS_ARRAY[3]}" )
    helper=( "/${BATS_BASENAME}/tests/fixtures/shell/${BATS_ARRAY[4]}${BATS_ARRAY[5]:+ ${BATS_ARRAY[5]}}" )
    shell=()
  fi
  command=( docker run -i --rm -v "${BATS_TOP}:/${BATS_BASENAME}" "${env[@]}" \
    "${BATS_ARRAY[1]}" "${BATS_ARRAY[2]}" "${c[@]}" "${helper[@]}" "${shell[@]}" )
  test "${BATS_SHOW_DOCKER_COMMAND}" -eq 0 || >&3 echo "${command[@]}"
  "${command[@]}"
}

export_funcs_path "${BASH_SOURCE[0]}"

