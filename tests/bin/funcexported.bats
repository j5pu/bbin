#!/usr/bin/env bats

f() { :; }

@test "funcexported bats::run " {
  bats::run
  assert_success
}

@test "filefuncs f " {
  bats::run
  assert_failure
}
