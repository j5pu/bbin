#!/usr/bin/env bats

setup_file() {
  export BATS_SHOW_DOCKER_COMMAND=0

  rebash
  . "${BATS_TOP}/tests/helpers/bin::shell.bash"

  local basename
  basename="$(bats::basename)"
  case "${basename}" in
    3*bullseye) IMAGE="python:${basename}" ;;
    3*slim) IMAGE="python:${basename}" ;;
    bullseye*) IMAGE="debian:${basename}" ;;
    kali*) IMAGE="kalilinux/${basename}" ;;
    ubuntu*) IMAGE="${basename}" ;;
    zsh*) IMAGE="zshusers/${basename}" ;;
  esac
  export IMAGE
}

@test "bash-4 ${IMAGE} bash plain" { assert_container; }
@test "bash-4 ${IMAGE} bash -c plain" { assert_container; }
@test "bash-4 ${IMAGE} bash plain bash" { assert_container; }
@test "bash-4 ${IMAGE} bash -c plain bash" { assert_container; }
@test "posix-dash ${IMAGE} bash plain dash" { assert_container; }
@test "posix-dash ${IMAGE} bash -c plain dash" { assert_container; }
@test "posix-dash ${IMAGE} bash plain sh" { assert_container; }
@test "posix-dash ${IMAGE} bash -c plain sh" { assert_container; }

@test "bash-4 ${IMAGE} bash shebang" { assert_container; }
@test "posix-dash ${IMAGE} bash -c shebang" { assert_container; }
@test "bash-4 ${IMAGE} bash shebang bash" { assert_container; }
@test "bash-4 ${IMAGE} bash -c shebang bash" { assert_container; }
@test "posix-dash ${IMAGE} bash shebang dash" { assert_container; }
@test "posix-dash ${IMAGE} bash -c shebang dash" { assert_container; }
@test "posix-dash ${IMAGE} bash shebang sh" { assert_container; }
@test "posix-dash ${IMAGE} bash -c shebang sh" { assert_container; }
