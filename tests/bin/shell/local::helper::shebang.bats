#!/usr/bin/env bats

setup_file() { export PATH="${BATS_TOP}/tests/fixtures/shell:${PATH}"; }

@test "shebang " {
  bats::run
  assert_output sh
}

@test "shebang /bin/bash " {
  ismacos || skip
  bats::run
  assert_output "$(basename "${BATS_ARRAY[1]}")"
}

@test "shebang bash " {
  bats::run
  assert_output "${BATS_ARRAY[1]}"-4
}

@test "shebang dash " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "shebang ksh " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "shebang sh " {
  bats::run
  assert_output "${BATS_ARRAY[1]}"
}

@test "shebang zsh" {
  bats::run
  assert_output "${BATS_ARRAY[1]}"
}
