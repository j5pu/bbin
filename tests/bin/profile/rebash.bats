#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/test_helpers.bash"; export BBIN_DEBUG=1;}

# TODO: check number of times with BBIN_DEBUG ...

@test "$(bats::basename)" {
  bats::run
  assert_success
  assert_output - <<EOF
1 environment
EOF
}
