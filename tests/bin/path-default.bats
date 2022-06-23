#!/usr/bin/env bats

@test "$(bats::basename) " { bats::success; assert_output --regexp ".*bin.*"; }

@test "assert::helps default \$PATH value" {
  bats::success
}
