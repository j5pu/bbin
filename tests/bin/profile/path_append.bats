#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }
# FIXME: Aqui lo dejo no funciona con espacio: A="/t a" && path_in "/t a" A

@test "path_append '/t a' && path_append '/t a' && path_in '/t a'" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_append '/t a' && path_append '/t a' && path_in '/t a' && assert_path \"${BATS_FILE_PATH}:/t a\"" {
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
