#!/usr/bin/env bats

f() { :; }

@test "assert::helps checks if function is exported " {
  bats::success
}

@test "$(bats::basename) bats::run " {
  bats::run
  assert_success
}

@test "$(bats::basename) f " {
  bats::run
  assert_failure
}
