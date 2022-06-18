#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }

_function() { :; }

@test "$(bats::basename)" {
  "${BATS_TEST_DESCRIPTION}"

  run funcexported setup_file
  assert_success

  run funcexported _function
  assert_failure
}
