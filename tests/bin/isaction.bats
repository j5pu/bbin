#!/usr/bin/env bats

setup_file() { export HELPS_LINE="is GitHub Actions is running the workflow?"; }

@test "$(bats::basename) " {
  bats::run
  if [ "${GITHUB_RUN_ID-}" ]; then
    assert_success
  else
    assert_failure
  fi
}

@test "assert::helps " { bats::success; }

@test "$(bats::basename) foo " {
  bats::failure
  assert_line "${HELPS_LINE}"
  assert_line "$(bats::basename): foo: invalid option/argument"
}
