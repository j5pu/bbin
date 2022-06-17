#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }

@test "path_add_exist '/t a' && path_add_exist '/t a' && ! path_in '/t a' && assert_path \"${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist . && path_add_exist . && path_in . && assert_path \".:${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist a MANPATH && ! path_in a MANPATH && assert_manpath \"${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist . MANPATH && path_in . MANPATH && assert_manpath \".:${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && path_add_exist . MANPATH && path_in . MANPATH && assert_manpath '.:'" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist '/t a' VAR && ! path_in '/t a' VAR && assert_equal '' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist . VAR && path_in . VAR && assert_equal . \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_append '/t a' VAR && path_add_exist '/t a' VAR && ! path_in '/t a' VAR && assert_equal '' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
