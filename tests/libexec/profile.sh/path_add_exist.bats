#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

@test "$(bats::basename) '/t a' && $(bats::basename) '/t a' && ! path_in '/t a' && assert_path \"${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) . && $(bats::basename) . && path_in \"$(pwd_p)\" && assert_path \"$(pwd_p):${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) a MANPATH && ! path_in a MANPATH && assert_manpath \"${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add_exist . MANPATH && path_in \"$(pwd_p)\" MANPATH && assert_manpath \"$(pwd_p):${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && $(bats::basename) . MANPATH && path_in \"$(pwd_p)\" MANPATH && assert_manpath \"$(pwd_p):\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) '/t a' VAR && ! path_in '/t a' VAR && assert_equal '' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) . VAR && path_in \"$(pwd_p)\" VAR && assert_equal \"$(pwd_p)\" \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_append '/t a' VAR && $(bats::basename) '/t a' VAR && ! path_in '/t a' VAR && assert_equal '' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
