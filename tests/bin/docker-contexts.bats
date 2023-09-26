#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/helpers.bash"; }

@test "$(bats::basename) " {
  skip::if::not::command docker
  bats::success
  assert_line "default"
}

@test "assert::helps list docker contexts" {
  bats::success
}
