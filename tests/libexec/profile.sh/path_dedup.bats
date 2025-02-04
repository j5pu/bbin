#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "PATH=/:\$PATH:/; $(bats::basename) && path_in '/' && assert_path \"/:${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PATH=\"/u a:\$PATH:/u a\"; $(bats::basename) && path_in '/u a' && assert_path \"/u a:${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PATH=\"\$PATH:/u a:/u a:\"; $(bats::basename) PATH && assert_path \"${BATS_FILE_PATH}:/u a\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "MANPATH=\"/u a:\$MANPATH:/u a\"; $(bats::basename) MANPATH && assert_manpath \"/u a:${BATS_SAVED_MANPATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "MANPATH=\"\$MANPATH/u a:/u a:\"; $(bats::basename) MANPATH && assert_manpath \"${BATS_SAVED_MANPATH}/u a:\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
