#!/usr/bin/env bats

. "${BATS_TOP}/tests/helpers/libexec::utils.bash::arrays.bash"

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) " {
  bats::failure
  assert_output --partial "declare: COMP_WORDS: not found"
}

@test "$(bats::basename) foo " {
  bats::failure
  assert_output --partial "declare: foo: not found"
}

@test "$(bats::basename) VARIABLE " {
  bats::failure
  assert_output 'cparray: undefined array: declare -x VARIABLE="1"'
}

@test "$(bats::basename) ARRAY" {
  bats::success
  ${BATS_TEST_DESCRIPTION}
  for i in "${!ARRAY[@]}"; do
    assert_equal "${ARRAY[$i]}" "${_ARRAY[$i]}"
  done
}

@test "unset \"ARRAY[1]\"" {
  ${BATS_TEST_DESCRIPTION}

  run $(bats::basename) ARRAY
  assert_success

  cparray ARRAY
  for i in "${!ARRAY[@]}"; do
    assert_equal "${ARRAY[$i]}" "${_ARRAY[$i]}"
  done
}

@test "$(bats::basename) ASSOCIATED " {
  bats::success
  ${BATS_TEST_DESCRIPTION}
  for i in "${!ASSOCIATED[@]}"; do
    assert_equal "${ASSOCIATED[$i]}" "${ASSOCIATED[$i]}"
  done
}
