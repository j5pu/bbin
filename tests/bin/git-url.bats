#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/helpers.bash"; }

@test "$(bats::basename) " { bats::success; assert_output --regexp "https://github.com/.*/${BATS_BASENAME}"; }

@test "$(bats::basename) origin" {
  skip::if::not::var GIT
  bats::success; assert_output --regexp "https://github.com/${GIT}/${BATS_BASENAME}";
}
#
#@test "$(bats::basename) https://github.com/octocat/Hello-World" { bats::success; assert_output "Hello-World"; }
#
#@test "$(bats::basename) https://github.com/octocat/Hello-World.git" { bats::success; assert_output "Hello-World"; }
