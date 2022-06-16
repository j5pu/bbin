#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }

@test "path_add /usr/tmp && path_add /usr/tmp && path_in /usr/tmp && assert_path \"/usr/tmp:${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add /usr/tmp MANPATH && path_in /usr/tmp MANPATH && assert_manpath \"/usr/tmp:${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && path_add /usr/tmp MANPATH && path_in /usr/tmp MANPATH && assert_manpath /usr/tmp:" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add /usr/tmp VAR && path_in /usr/tmp VAR && assert_equal /usr/tmp \$VAR" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
