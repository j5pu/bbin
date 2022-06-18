#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }

@test "$(bats::basename) foo " {
  bats::run
  assert_failure
}

@test "$(bats::basename) ls " {
  bats::run
  assert_success
}
