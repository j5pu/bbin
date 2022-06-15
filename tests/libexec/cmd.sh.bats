#!/usr/bin/env bats

setup_file() { . "$(bats::basename)"; NAME="$(basename "$(bats::basename)" .sh)"; export NAME; export -f "${NAME?}"; }


@test "type -t ${NAME}" {
  bats::run
  assert_output "function"
}

@test "${NAME} setup_file " {
  bats::run
  assert_success
  assert_output ""
}

@test "${NAME} setup_file sudo test_alias " {
  alias test_alias="ls"
  shopt -s expand_aliases
  bats::run
  assert_success
  assert_output ""
}

@test "${NAME} setup_file sudo foo " {
  bats::run
  assert_failure
  assert_output ""
}
