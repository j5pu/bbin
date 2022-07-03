#!/usr/bin/env bats

setup_file() {
  rebash
  . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"
  FUNC="$(bats::basename)"; export FUNC
}

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "path_add_exist '/t a' && path_add_exist '/t a' && ! path_in '/t a' && assert_path \"${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} . && ${FUNC} . && path_in '$(pwd_p)' && assert_path \"${BATS_FILE_PATH}:$(pwd_p)\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
@test "${FUNC} && ${FUNC} && path_in '$(pwd_p)' && assert_path \"${BATS_FILE_PATH}:$(pwd_p)\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} a && ! path_in a && assert_path \"${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} . MANPATH && path_append . MANPATH && assert_manpath \"${BATS_SAVED_MANPATH}$(pwd_p):\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && ${FUNC} . MANPATH && path_in \"$(pwd_p)\" MANPATH && assert_manpath \"$(pwd_p):\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} . VAR && path_in \"$(pwd_p)\" VAR && assert_equal \"$(pwd_p)\" \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_add . VAR && ${FUNC} '/t a' VAR && ! path_in '/t a' VAR && assert_equal \"$(pwd_p)\" \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
