#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/helpers.bash"; }

@test "$(bats::basename) " {
  skip::if::not::var GIT
  bats::success
  assert_output "${GIT}"
}

@test "$(bats::basename) origin" {
  skip::if::not::var GIT
  bats::success
  assert_output "${GIT}"
}

@test "$(bats::basename) https://github.com/octocat/Hello-World" { bats::success; assert_output "octocat"; }
