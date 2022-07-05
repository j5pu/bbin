#!/usr/bin/env bats

@test "assert::helps to upper case from args or stdin" {
  bats::success
}

@test "$(bats::basename)" {
  bats::success
}

@test "$(bats::basename) foo " {
  bats::success
  assert_output "${BATS_ARRAY[1]^^}"
}

@test "echo boo | $(bats::basename) foo" {
  bats::array

  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${BATS_ARRAY[4]^^}"
}

@test "echo boo | $(bats::basename)" {
  bats::array

  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${BATS_ARRAY[1]^^}"
}
