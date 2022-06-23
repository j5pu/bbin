#!/usr/bin/env bats

@test "$(bats::basename) " { bats::success; assert_output --regexp "https://github.com/.*/${BATS_BASENAME}"; }

@test "$(bats::basename) origin" { bats::success; assert_output --regexp "https://github.com/.*/${BATS_BASENAME}"; }
#
#@test "$(bats::basename) https://github.com/octocat/Hello-World" { bats::success; assert_output "Hello-World"; }
#
#@test "$(bats::basename) https://github.com/octocat/Hello-World.git" { bats::success; assert_output "Hello-World"; }
