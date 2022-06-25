#!/usr/bin/env bats

@test "$(bats::basename) " {
  bats::success
  assert_output "main"
}

@test "git -C '${PWD}' default " {
  bats::success
  assert_output "main"
}

@test "$(bats::basename) https://github.com/octocat/Hello-World" {
  bats::success
  assert_output "master"
}

@test "git -C '${PWD}' default https://github.com/octocat/Hello-World" {
  bats::success
  assert_output "master"
}

@test "path=$(bats::tmp repo) && cd \${path} && git init && $(bats::basename) " {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output --regexp "$(bats::basename): .*/repo: no remote configured"
}


