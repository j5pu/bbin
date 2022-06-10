#!/usr/bin/env bats

@test "\$PATH " {
  run echo "${PATH}"
  assert_output --regexp ".*${BATS_TOP}/bin:.*"
}

@test "bats::env " {
  bats::run
  while read -r var; do
    assert [ -n "${!var}" ]
    run declare -p "${var}"
    assert_output --regexp "declare -x ${var}="
  done < <(sed 's/export //g' "${BATS_TOP}/.env" | cut -d '=' -f 1)
}
