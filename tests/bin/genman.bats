#!/usr/bin/env bats

repo() {
  test_repo_name="$(bats::basename "$@")"
  bats::remote "$@"
  export SRC_REPO="${BATS_TOP}/tests/fixtures/${test_repo_name}"
  cp -r "${SRC_REPO}"/* "${BATS_REMOTE[0]}"
  echo "${BATS_REMOTE[0]}"
}

# TODO: test when function not found, test when script not found
#    test man changes (real and not real), add directories in path with path_add_exist

@test "$(bats::basename) " {
  bats::success
}

@test "$(bats::basename) $(repo success)/bin " {
  bats::success
}

#
#@test "genman: repo fail " {
#  repo
#  cp "${REPO_TEST_TMPDIR}/src/man/repo_test_main.adoc" "${REPO_TEST_TMPDIR}/src/man/repo_test_fail.adoc"
#  run genman "${REPO_TEST_TMPDIR}/bin"
#  assert_failure
#  assert_output - <<STDIN
#Invalid Function Comment Block for file: bin/repo_test_fail and function: main
#
#@ BLOCK START @
##!/bin/sh
#
##
## repo test fail because no function comment in main
#
#main() {
#@ BLOCK END @
#STDIN
#}
