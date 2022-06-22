#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

@test "PATH=/usr/tmp:${PATH}; path_in /usr/tmp && $(bats::basename) /usr/tmp && path_in /usr/tmp " {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_equal "${PATH}" "${BATS_FILE_PATH}"
  refute [ "${PATH: -1}" = ":" ]
}

@test "PATH=${PATH}:/usr/tmp:; path_in /usr/tmp && $(bats::basename) /usr/tmp && path_in /usr/tmp " {
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

@test "$(bats::basename) last component -> '' " {
  for _part in $(echo "${MANPATH}" | tr ':' '\n'); do
    $(bats::basename) "${_part}" MANPATH
  done
  assert_equal "${MANPATH}" ""
}
