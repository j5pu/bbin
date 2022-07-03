#!/usr/bin/env bats

setup_file() { rebash; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) " {
  bats::success
  assert_output "$(pwd -P)"
}

@test "$(bats::basename) . " {
  bats::success
  assert_output "$(pwd -P)"
}

@test "$(bats::basename) ${BATS_TOP}/README.md " {
  bats::success
  assert_output "$(pwd -P)"
}

@test "$(bats::basename) foo " {
  bats::success
  assert_output "foo"
}
