#!/usr/bin/env bats

setup_file() { . utils.bash; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) ls " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename) foo " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename) setup_file " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename) setup_file sudo test_alias " {
  alias test_alias="ls"
  shopt -s expand_aliases
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename) setup_file sudo foo " {
  bats::run
  assert_failure
  assert_output ""
}
