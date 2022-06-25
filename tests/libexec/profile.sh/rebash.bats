#!/usr/bin/env bats

setup_file() { rebash; export BBIN_DEBUG=1;}

# TODO: check number of times with BBIN_DEBUG ...

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename)" {
  bats::success
  assert_equal "$(echo "$output" | wc -l | sed 's/ //g')" 1
  assert_output --regexp "environment"
}
