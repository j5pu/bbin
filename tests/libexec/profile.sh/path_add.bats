#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) . && path_add . && path_in \"$(pwd -P)\" && assert_path \"$(pwd -P):${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) '/t a' && path_add '/t a' && path_in '/t a' && assert_path \"/t a:${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add '/t a' MANPATH && path_in '/t a' MANPATH && assert_manpath \"/t a:${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && path_add '/t a' MANPATH && path_in '/t a' MANPATH && assert_manpath '/t a:'" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) '/t a' VAR && path_in '/t a' VAR && assert_equal '/t a' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "VAR=/; path_append '/t a' VAR && path_add '/t a' VAR && path_in '/t a' VAR && assert_equal '/t a:/' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
