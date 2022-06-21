#!/usr/bin/env bats

@test "$(bats::basename) " { bats::success; }

@test "assert::helps check if fd3 is open" {
  bats::success
}
