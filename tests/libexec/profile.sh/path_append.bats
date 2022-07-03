#!/usr/bin/env bats

setup_file() {
  rebash
  . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"
  FUNC="$(bats::basename)"; export FUNC
}

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "${FUNC} . && path_append . && path_in \"$(pwd -P)\" && assert_path \"${BATS_FILE_PATH}:$(pwd -P)\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} && ${FUNC} && path_in \"$(pwd -P)\" && assert_path \"${BATS_FILE_PATH}:$(pwd -P)\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} '/t a' && path_append '/t a' && path_in '/t a' && assert_path \"${BATS_FILE_PATH}:/t a\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_append '/t a' MANPATH && path_append '/t a' MANPATH && assert_manpath \"${BATS_SAVED_MANPATH}/t a:\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "unset MANPATH && ${FUNC} '/t a' MANPATH && path_in '/t a' MANPATH && assert_manpath '/t a:'" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "${FUNC} '/t a' VAR && path_in '/t a' VAR && assert_equal '/t a' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "VAR=/; path_add '/t a' VAR && path_append '/t a' VAR && path_in '/t a' VAR && assert_equal '/:/t a' \"\$VAR\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
