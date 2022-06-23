#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/libexec::utils.sh::cd_top.bash"; }

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "cd /tmp && $(bats::basename).sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output - <<EOF
cd_top: /tmp: fatal: not a git repository (or any of the parent directories): .git
${OUTPUT_FAILURE}
EOF
}

@test "cd /tmp && $(bats::basename)-e.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output - <<EOF
cd_top: /tmp: fatal: not a git repository (or any of the parent directories): .git
EOF
}

@test "cd ${GIT_DIRECTORY} && $(bats::basename).sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${OUTPUT_SUCCESS}"
}

@test "cd ${GIT_DIRECTORY} && $(bats::basename)-e.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${OUTPUT_SUCCESS}"
}

