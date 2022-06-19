#!/usr/bin/env bats

f() { :; }

alias aliases="foo"

@test "$(bats::basename) " {
  bats::run
  assert_failure
}

@test "assert::helps check silently if command is installed, does not check functions or aliases" {
  bats::success
}

@test "$(bats::basename) aliases " {
  bats::run
  assert_failure
}

@test "$(bats::basename) foo " {
  bats::run
  assert_failure
}

@test "$(bats::basename) f " {
  bats::run
  assert_failure
}

@test "$(bats::basename) ls " {
  bats::run
  assert_success
}
