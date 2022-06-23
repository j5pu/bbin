#!/usr/bin/env bats

setup_file() { rebash; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) foo" { bats::success; }

@test "t='$(bats::tmp)'; $(bats::basename) \${t}" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "t='$(bats::tmp)'; echo 'func0() { :; }' > \${t}/f; $(bats::basename) \${t} && command -v func0" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
