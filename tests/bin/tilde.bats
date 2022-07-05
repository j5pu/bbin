#!/usr/bin/env bats

@test "assert::helps replace tilde at the beginning of each line from arguments or stdin with \$HOME" {
  bats::success
}

@test "$(bats::basename)" {
  bats::success
}

@test "$(bats::basename) ~ " {
  bats::success
  assert_output "${HOME}"
}

@test "$(bats::basename) ~ ~/foo" {
  bats::success
  assert_output - <<EOF
${HOME}
${HOME}/foo
EOF
}

@test "echo ~ | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${HOME}"
}

@test "printf '%s\n' ~ ~/foo | $(bats::basename)" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output - <<EOF
${HOME}
${HOME}/foo
EOF
}
