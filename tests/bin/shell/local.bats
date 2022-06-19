#!/usr/bin/env bats

setup_file() { export PATH="${BATS_TOP}/tests/fixtures/shell:${PATH}"; }

lib() { "$@" ". shell; echo \$SH"; }

@test ". shell" {
  ${BATS_TEST_DESCRIPTION}
  assert_equal "${SH}" "bash-4"
}

@test "lib /bin/bash -c " {
  ismacos || skip
  bats::run
  assert_output "$(basename "${BATS_ARRAY[1]}")"
}

@test "lib bash -c " {
  bats::run
  assert_output "${BATS_ARRAY[1]}"-4
}

@test "lib dash -c " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "lib ksh -c " {
  bats::run
  assert_output posix-"${BATS_ARRAY[1]}"
}

@test "lib sh -c " {
  bats::run
  if ismacos; then
    assert_output "${BATS_ARRAY[1]}"
  elif isdebian; then
    assert_output posix-dash
  else
    skip
  fi
}

@test "lib zsh -c " {
  bats::run
  assert_output "${BATS_ARRAY[1]}"
}

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
