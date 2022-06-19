#!/usr/bin/env bats

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
