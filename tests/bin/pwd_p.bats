#!/usr/bin/env bats

@test "assert::helps physical pwd for path if it is a directory or for dirname if path exists (default: pwd)" {
  bats::success
}

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
