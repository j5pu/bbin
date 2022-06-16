#!/usr/bin/env bats

setup_file() { export BATS_FILE_PATH="${PATH}"; }

@test "PATH=/usr/tmp:${PATH}; path_in /usr/tmp && path_pop /usr/tmp && path_in /usr/tmp " {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_equal "${PATH}" "${BATS_FILE_PATH}"
  refute [ "${PATH: -1}" = ":" ]
}

@test "PATH=${PATH}:/usr/tmp:; path_in /usr/tmp && path_pop /usr/tmp && path_in /usr/tmp " {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_equal "${PATH}" "${BATS_FILE_PATH}"
  refute [ "${PATH: -1}" = ":" ]
}

@test "MANPATH=${MANPATH}:/usr/tmp:;path_in /usr/tmp MANPATH && path_pop /usr/tmp MANPATH && path_in /usr/tmp MANPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_equal "${MANPATH}" "${BATS_SAVED_MANPATH}"
  assert_equal "${MANPATH: -1}" ":"
}

@test "path_pop last component -> '' " {
  for _part in $(echo "${MANPATH}" | tr ':' '\n'); do
    path_pop "${_part}" MANPATH
  done
  assert_equal "${MANPATH}" ""
}
