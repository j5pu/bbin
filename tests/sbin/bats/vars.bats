#!/usr/bin/env bats

@test "\$BATS_* " {

  for i in BATS_BASENAME BATS_EXECUTABLE BATS_SHARE BATS_TOP; do
    echo "${!i}"
    assert [ -n "${!i}" ]
  done
}

@test "\$BATS_* directories " { assert_dir_exist "${BATS_TOP}"; }

@test "\$BATS_BASENAME " { assert_equal "${BATS_BASENAME}" "$(basename "${BATS_TOP}")"; }

@test "\$BATS_EXECUTABLE " { assert_file_executable "${BATS_EXECUTABLE}"; }

@test "\$BATS_TOP " { assert_equal "${BATS_TOP}" "$(git rev-parse --show-toplevel)"; }

