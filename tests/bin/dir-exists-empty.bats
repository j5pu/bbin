#!/usr/bin/env bats

@test "assert::helps checks if it is a directory, and it is empty (default: cwd)" {
  bats::success
}

@test "$(bats::basename) " {
  bats::run
  assert_failure
}

@test "$(bats::basename) foo" {
  bats::run
  assert_failure
}

@test "d=$(bats::tmp d); $(bats::basename) \${d}" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "d1=$(bats::tmp d1); touch \${d1}/a; $(bats::basename) \${d1}" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
}

@test "d1=$(bats::tmp d1); mkdir \${d1}/a; $(bats::basename) \${d1}" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
}

@test "d2=$(bats::tmp d2); d3=$(bats::tmp d3); touch \${d2}/.a; ln -s \${d2}/.a \${d3}/a; $(bats::basename) \${d3}" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
}

@test "$(bats::basename) /tmp " {
  bats::run
  assert_failure
}
