#!/usr/bin/env bats

f() { :; }

alias aliases="foo"

@test "$(bats::basename) " { bats::failure; }

@test "assert::helps check silently if command is installed, does not check functions or aliases" {
  bats::success
}

@test "$(bats::basename) aliases " { bats::failure; }

@test "$(bats::basename) foo " { bats::failure; }

@test "$(bats::basename) f " { bats::failure; }

@test "$(bats::basename) ls " { bats::success; }
