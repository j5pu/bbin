#!/usr/bin/env bats

repo() {
  bats::remote "$@"
  cp -r "$(src_repo)"/* "${BATS_REMOTE[0]}"
  echo "${BATS_REMOTE[0]}"
}

src_repo() {
#  test_repo_name="$(bats::basename)"
#
#  export SRC_REPO="${BATS_TOP}/tests/fixtures/${test_repo_name}"
  echo "${BATS_TOP}/tests/fixtures/$(bats::basename)"
}

ls_man() { ls -la "${BATS_ARRAY[1]}/share/man/man${1}"; }

# TODO: test when function not found

@test "$(bats::basename) " {
  bats::success
}

@test "$(bats::basename) $(repo success)/bin " {
  bats::success
}

@test "$(bats::basename) $(repo no-change) " {
  bats::success
  ls_1="$(ls_man 1)"
  ls_7="$(ls_man 7)"
  run genman --change-mansource
  assert_success
  ls_1_new="$(ls_man 1)"
  ls_7_new="$(ls_man 7)"
  assert_equal "${ls_1}" "${ls_1_new}"
  assert_equal "${ls_7}" "${ls_7_new}"
}
@test "$(bats::basename) $(repo script-not-found) " {
  bats::array

  cp "$(src_repo)/src/man/repo_test_main.adoc" "${BATS_ARRAY[1]}/src/man/script-not-found.adoc"
  bats::failure
  assert_output - <<STDIN
Invalid Function Comment Block for file: bin/repo_test_fail and function: main

@ BLOCK START @
#!/bin/sh

#
# repo test fail because no function comment in main

main() {
@ BLOCK END @
STDIN
}

@test "$(bats::basename) $(repo invalid-description-script) " {
  bats::array

  relative=""
  cp "$(src_repo)/src/man/repo_test_main.adoc" "${BATS_ARRAY[1]}/src/man/$(basename "${BATS_ARRAY[1]}").adoc"
  bats::failure
  assert_output - <<STDIN
Invalid Function Comment Block for file: bin/repo_test_fail and function: main

@ BLOCK START @
#!/bin/sh

#
# repo test fail because no function comment in main

main() {
@ BLOCK END @
STDIN
}
