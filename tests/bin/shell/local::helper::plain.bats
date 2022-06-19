#!/usr/bin/env bats

setup_file() { export PATH="${BATS_TOP}/tests/fixtures/shell:${PATH}"; }

@test "plain " {
  bats::run
  assert_output bash-4
}

@test "plain /bin/bash " {
  ismacos || skip
  bats::run
  assert_output "$(basename "${BATS_ARRAY[1]}")"
}

@test "plain dash " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "plain ksh " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "plain sh" {
  bats::run
  assert_output "${BATS_ARRAY[1]}"
}

@test "plain zsh " {
  bats::run
  assert_output "${BATS_ARRAY[1]}"
}
