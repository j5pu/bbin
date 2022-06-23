#!/usr/bin/env bats

setup_file() { rebash; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) foo " { bats::failure; }

@test "$(bats::basename) ls " { bats::success;
}
