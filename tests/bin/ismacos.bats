#!/usr/bin/env bats

setup_file() { export HELPS_LINE="is running on macOS?"; }

@test "$(bats::basename) " {
  bats::run
  if [ "$(uname -s)" = "Darwin" ]; then
    assert_success
  else
    assert_failure
  fi
}

@test "assert::helps" { bats::success; }

@test "$(bats::basename) foo " {
  bats::failure
  assert_line "${HELPS_LINE}"
  assert_line "$(bats::basename): foo: invalid option/argument"
}
