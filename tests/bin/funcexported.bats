#!/usr/bin/env bats

f() { :; }

@test "$(bats::basename) bats::run " {
  bats::run
  assert_success
}

@test "$(bats::basename) f " {
  bats::run
  assert_failure
}
