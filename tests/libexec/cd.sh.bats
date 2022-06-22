#!/usr/bin/env bats

setup_file() { . "${BATS_TOP}/tests/helpers/libexec::cmd.sh.bash"; }

@test "cd /tmp && cd_top.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output - <<EOF
cd_top: /tmp: fatal: not a git repository (or any of the parent directories): .git
${OUTPUT_FAILURE}
EOF
}

@test "cd /tmp && cd_top-e.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output - <<EOF
cd_top: /tmp: fatal: not a git repository (or any of the parent directories): .git
EOF
}

@test "cd /tmp && cd_top_exit.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_failure
  assert_output - <<EOF
cd_top: /tmp: fatal: not a git repository (or any of the parent directories): .git
EOF
}

@test "cd ${GIT_DIRECTORY} && cd_top.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${OUTPUT_SUCCESS}"
}

@test "cd ${GIT_DIRECTORY} && cd_top-e.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${OUTPUT_SUCCESS}"
}

@test "cd ${GIT_DIRECTORY} && cd_top_exit.sh" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_success
  assert_output "${OUTPUT_SUCCESS}"
}
