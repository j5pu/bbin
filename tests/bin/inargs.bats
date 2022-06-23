#!/usr/bin/env bats

setup_file() { export HELPS_LINE="checks if first argument in any of the following arguments, no arguments is help"; }

@test "$(bats::basename) " { bats::failure; assert_line "${HELPS_LINE}"; }

@test "$(bats::basename) --help " { bats::failure; }

@test "$(bats::basename) --help foo bar" { bats::failure; }

@test "$(bats::basename) array \"\${arguments[@]}\" " {
  arguments=(array with arguments)
  assert "$(bats::basename)" array "${arguments[@]}"
}
