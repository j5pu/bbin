#!/usr/bin/env bats

setup_file() { rebash; }

@test "$(bats::basename) foo " {
  bats::run
  assert_failure
}

@test "$(bats::basename) ls " {
  bats::run
  assert_success
}
