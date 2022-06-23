#!/usr/bin/env bats

. "${BATS_TOP}/tests/helpers/libexec::utils.bash::arrays.bash"

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) value foo " {
  bats::failure
  assert_output --partial "declare: foo: not found"
}

@test "$(bats::basename) value VARIABLE " {
  bats::failure
  assert_output 'cparray: undefined array: declare -x VARIABLE="1"'
}

@test "$(bats::basename) bar ARRAY " {
  bats::success
  assert_output 2
}

@test "$(bats::basename) bar ASSOCIATED " {
  bats::success
  assert_output key2
}
