#!/usr/bin/env bats

setup_file() {
  export BATS_SHOW_DOCKER_COMMAND=0

  rebash
  . "${BATS_TOP}/tests/helpers/libexec::shell.sh.bash"

  local basename
  basename="$(bats::basename)"
  case "${basename}" in
    bash*) IMAGE="${basename}" ;;
  esac
  export IMAGE
}

@test "bash-4 ${IMAGE} bash plain" { assert_container; }
@test "bash-4 ${IMAGE} bash -c plain" { assert_container; }
@test "bash-4 ${IMAGE} bash plain bash" { assert_container; }
@test "bash-4 ${IMAGE} bash -c plain bash" { assert_container; }
@test "bash-4 ${IMAGE} sh plain bash" { assert_container; }
@test "bash-4 ${IMAGE} sh -c plain bash" { assert_container; }
@test "posix-busybox ${IMAGE} sh plain sh" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c plain sh" { assert_container; }

@test "bash-4 ${IMAGE} bash shebang" { assert_container; }
@test "posix-busybox ${IMAGE} bash -c shebang" { assert_container; }
@test "bash-4 ${IMAGE} bash shebang bash" { assert_container; }
@test "bash-4 ${IMAGE} bash -c shebang bash" { assert_container; }
@test "bash-4 ${IMAGE} sh shebang bash" { assert_container; }
@test "bash-4 ${IMAGE} sh -c shebang bash" { assert_container; }
@test "posix-busybox ${IMAGE} sh shebang sh" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c shebang sh" { assert_container; }
