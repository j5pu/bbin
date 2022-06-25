#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/helpers.bash"; }

@test "$(bats::basename) " {
  skip::if::action
  skip::if::not::command ssh
  bats::success
}

@test "$(bats::basename) ${GIT}" {
  skip::if::not::var GIT
  skip::if::not::command ssh
  bats::success
}

@test "git -C '${PWD}' ssh ${GIT}" {
  skip::if::not::var GIT
  skip::if::not::command ssh
  bats::success
}

@test "$(bats::basename) foo" {
  skip::if::not::var GIT
  skip::if::not::command ssh
  bats::failure
  assert_output "git-ssh: foo: SSH access to GitHub failed."
}
