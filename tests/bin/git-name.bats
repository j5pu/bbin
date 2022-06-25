#!/usr/bin/env bats

@test "$(bats::basename) " { bats::success; assert_output "${BATS_BASENAME}"; }

@test "$(bats::basename) origin" { bats::success; assert_output "${BATS_BASENAME}"; }

@test "$(bats::basename) https://github.com/octocat/Hello-World" { bats::success; assert_output "Hello-World"; }

@test "$(bats::basename) https://github.com/octocat/Hello-World.git" { bats::success; assert_output "Hello-World"; }

@test "git -C '${PWD}' name https://github.com/octocat/Hello-World.git" {
  bats::success
  assert_output "Hello-World"
}

@test "$(bats::basename) git+file://octocat/Hello-World" { bats::success; assert_output "Hello-World"; }

@test "$(bats::basename) git+https://github.com/octocat/Hello-World" { bats::success; assert_output "Hello-World"; }

@test "$(bats::basename) git+ssh://github.com/octocat/Hello-World" { bats::success; assert_output "Hello-World"; }

@test "$(bats::basename) git@github.com:octocat/Hello-World" { bats::success; assert_output "Hello-World"; }

