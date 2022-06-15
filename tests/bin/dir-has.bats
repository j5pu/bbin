#!/usr/bin/env bats

@test "$(bats::basename) " {
  bats::run
  assert_success
}

@test "$(bats::basename) ~ " {
  bats::run
  assert_success
}

@test "$(bats::basename) foo" {
  bats::run
  assert_failure
  assert_output "foo"
}

@test "find . -type d | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "echo $(bats::tmp d1) | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output --regexp ".*/d1"
}

@test "{ echo /tmp; echo $(bats::tmp d2); } | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output --regexp ".*/d2"
}

@test "{ echo /tmp; echo ~; } | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
