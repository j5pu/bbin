#!/usr/bin/env bats

@test "assert::helps is directory or directories empty, including hidden files and folders or does not exist" {
  bats::success
}

@test "$(bats::basename) " { bats::failure; assert_output "."; }

@test "$(bats::basename) . " { bats::failure; assert_output "."; }

@test "$(bats::basename) ~ " { bats::failure; assert_output "~"; }

@test "$(bats::basename) /tmp ~ " {
  bats::failure
  assert_output - <<EOF
/tmp
~
EOF
}

@test "$(bats::basename) foo" { bats::success; assert_output ""; }

@test "$(bats::basename) foo $(bats::tmp empty)" { bats::success; assert_output ""; }

@test "$(bats::basename) foo boo" { bats::success; assert_output ""; }

@test "$(bats::basename) foo ~" { bats::failure; assert_output "~"; }

@test "echo $(bats::tmp d1) | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output ""
}

@test "{ echo /tmp; echo $(bats::tmp d2); } | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output /tmp
}

@test "{ echo /tmp; echo '~'; } | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output - <<EOF
/tmp
~
EOF
}
