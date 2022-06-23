#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "path_in /bin " { bats::success; }

@test "$(bats::basename) /tmp/bin " { bats::failure; }

@test "$(bats::basename) /tmp/bin MANPATH " { bats::failure; }

@test "PYTHONPATH=/tmp/bin:/usr/bin; $(bats::basename) /tmp/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PYTHONPATH=/tmp/bin:/usr/bin; $(bats::basename) /usr/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PYTHONPATH=/tmp/bin:/usr/bin:; $(bats::basename) /usr/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "$(bats::basename) /tmp/bin PYTHONPATH " { bats::failure; }
