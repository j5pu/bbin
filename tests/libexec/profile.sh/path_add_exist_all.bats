#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/libexec::profile.sh::path.bash"; }

all() {
  tmp="$(pwd_p "$1")"
  $(bats::basename) "${tmp}"
  assert_path "${tmp}/sbin:${tmp}/bin:${tmp}/libexec:${BATS_FILE_PATH}" && \
  assert_manpath "${tmp}/share/man:${BATS_SAVED_MANPATH}" && \
  assert_equal "${INFOPATH}" "${tmp}/share/info:${BATS_SAVED_INFOPATH}"
}

export -f all

@test "funcexported $(bats::basename) " { bats::success; }

@test "type -t $(bats::basename)" { bats::success; assert_output "function"; }

@test "$(bats::basename) ." {
  ${BATS_TEST_DESCRIPTION}

  ALL_PATH="${BATS_FILE_PATH}"
  for i in libexec bin sbin; do
    path_add_exist "./${i}" ALL_PATH
  done
  assert_path "${ALL_PATH}"
}

@test "d=$(bats::tmp d); $(bats::basename) \${d} && assert_path \"${BATS_FILE_PATH}\"" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}

@test "t=$(bats::tmp t); mkdir -p \${t}/{bin,sbin,share,libexec}; mkdir -p \${t}/share/{info,man}; all \${t}" {
  run bash -c "${BATS_TEST_DESCRIPTION}"
  assert_success
}
