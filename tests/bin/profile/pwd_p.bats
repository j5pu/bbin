#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/test_helpers.bash"; }

@test "$(bats::basename) " {
  bats::run
  assert_output "$(pwd -P)"
}

@test "$(bats::basename) . " {
  bats::run
  assert_output "$(pwd -P)"
}

@test "$(bats::basename) foo " {
  bats::run
  assert_output "foo"
}
