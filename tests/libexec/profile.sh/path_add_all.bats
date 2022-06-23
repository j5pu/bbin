#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

all() {
  tmp="$(pwd_p "$1")"
  $(bats::basename) "${tmp}"
  assert_path "${tmp}/sbin:${tmp}/bin:${tmp}/libexec:${BATS_FILE_PATH}" && \
  assert_manpath "${tmp}/share/man:${BATS_SAVED_MANPATH}" && \
  assert_equal "${INFOPATH}" "${tmp}/share/info:${BATS_SAVED_INFOPATH}"
}

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

export -f all

@test "t=/${BATS_BASENAME}; all \${t}" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
