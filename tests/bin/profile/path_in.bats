#!/usr/bin/env bats

@test "path_in /bin " {
  bats::run
  assert_success
}

@test "path_in /tmp/bin " {
  bats::run
  assert_failure
}

@test "path_in /tmp/bin MANPATH " {
  bats::run
  assert_failure
}

@test "PYTHONPATH=/tmp/bin:/usr/bin; path_in /tmp/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PYTHONPATH=/tmp/bin:/usr/bin; path_in /usr/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "PYTHONPATH=/tmp/bin:/usr/bin:; path_in /usr/bin PYTHONPATH" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "path_in /tmp/bin PYTHONPATH " {
  bats::run
  assert_failure
}
