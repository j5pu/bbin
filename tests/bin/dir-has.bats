#!/usr/bin/env bats

@test "assert::helps directory/s exist and have files, including hidden files and folders or does not exist" {
  bats::success
}

@test "$(bats::basename) " { bats::success; }

@test "$(bats::basename) . " { bats::success; }

@test "$(bats::basename) ~ " { bats::success; }

@test "$(bats::basename) foo" { bats::failure; assert_output "foo"; }

@test "find . -type d | $(bats::basename)" {
  mkdir -p .git/empty
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_line "./.git/empty"
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
