#!/usr/bin/env bats

@test "assert::helps to lower case from args or stdin" {
  bats::success
}

@test "$(bats::basename)" {
  bats::success
}

@test "$(bats::basename) FOO " {
  bats::success
  assert_output "${BATS_ARRAY[1],,}"
}

@test "echo BOO | $(bats::basename) FOO" {
  bats::array

  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${BATS_ARRAY[4],,}"
}

@test "echo BOO | $(bats::basename)" {
  bats::array

  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${BATS_ARRAY[1],,}"
}
