#!/usr/bin/env bats

setup_file() { rebash; }

_function() { :; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename)" {
  "${BATS_TEST_DESCRIPTION}"

  run funcexported setup_file
  assert_success

  run funcexported _function
  assert_success
}
