#!/usr/bin/env bats

setup_file() { rebash; }

adoc() { echo "$(src_repo)/src/man/repo_test_file.adoc"; }

assert_name() {
  export COLUMNS=160
  run man -P cat "$1" "$2"
  assert_line --partial "       ${2} - ${DESCRIPTIONS[$2]}"
}

cp_adoc() {
  basename="$(basename "${BATS_ARRAY[1]}")"
  cp "$(adoc)" "${BATS_ARRAY[1]}/src/man/${basename}.adoc"
}

ls_man() { ls -la "${BATS_ARRAY[1]}/share/man/man${1}"; }

repo() {
  bats::remote "$@"
  cp -r "$(src_repo)"/* "${BATS_REMOTE[0]}"
  echo "${BATS_REMOTE[0]}"
}

src_repo() { echo "${BATS_TOP}/tests/fixtures/$(bats::basename)"; }

test_descriptions() {
  for i in "${!DESCRIPTIONS[@]}"; do
    assert_name "$1" "$i"
  done
}

@test "$(bats::basename) " {
  bats::success
}

@test "$(bats::basename) $(adoc)" {
  bats::success
  assert_output --regexp "man .*/$(basename "${BATS_ARRAY[1]}" .adoc).1"
}

@test "$(bats::basename) $(repo success)/bin " {
  bats::success

  path_add_exist_all "$(dirname "${BATS_ARRAY[1]}")"
  declare -Ax DESCRIPTIONS

  DESCRIPTIONS=(
    ["repo_test"]="repo_test script in sh for the repository README.adoc and no main() function"
    ["repo_test::function_sh_f"]="function f with spaces at the beginning and at the end and ::"
    ["repo_test_file"]="repo_test_file is a test script ending with . and with spaces at the beginning"
    ["repo_test_function_bash_a"]="bash library function a with spaces and"
    ["repo_test_function_sh_a"]="function with() space and {"
    ["repo_test_function_sh_b"]="function with() and ()"
    ["repo_test_function_sh_c"]="function with() if true; then true; fi"
    ["repo_test_function_sh_d"]="function with(){"
    ["repo_test_function_sh_e"]="function with()("
  )
  test_descriptions 1

  DESCRIPTIONS=(
    ["repo_test.sh"]="repo_test.sh is a test library with functions"
  )
  test_descriptions 7

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

  cp_adoc

  bats::failure
  assert_output "$(bats::basename): \
${BATS_ARRAY[1]}/libexec: function description or executable not found for: $(basename "${BATS_ARRAY[1]}")"
}

@test "$(bats::basename) $(repo repo_test_empty_description) " {
  bats::array

  cp_adoc

  bats::failure
assert_output "$(bats::basename): \
${BATS_ARRAY[1]}/libexec/${basename}.sh: empty comment block for function: ${basename}"
}

@test "$(bats::basename) $(repo repo_test_invalid_block_start)" {
  bats::array

  cp_adoc

  bats::failure
  assert_output - <<STDIN
$(bats::basename): ${BATS_ARRAY[1]}/libexec/${basename}.sh: invalid comment block for function: ${basename}
@ BLOCK START @
#######################################
#   repo_test_invalid block start
######################################
@ BLOCK END @
STDIN
}

@test "$(bats::basename) $(repo repo_test_invalid_block_end)" {
  bats::array

  cp_adoc

  bats::failure
  assert_output - <<STDIN
$(bats::basename): ${BATS_ARRAY[1]}/libexec/${basename}.sh: invalid comment block for function: ${basename}
@ BLOCK START @
######################################
#   repo_test_invalid block end
#######################################
@ BLOCK END @
STDIN
}

@test "$(bats::basename) $(repo repo_test_invalid_file) " {
  bats::array

  cp_adoc

  bats::failure
assert_output "$(bats::basename): \
${BATS_ARRAY[1]}/bin/${basename}: empty file description for: ${basename}"
}

@test "$(bats::basename) $(repo repo_test_invalid_file_line_comment) " {
  bats::array

  cp_adoc

  bats::failure
assert_output "$(bats::basename): \
${BATS_ARRAY[1]}/bin/${basename}: empty file description and start block comment found for: ${basename}"
}
