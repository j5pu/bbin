#!/usr/bin/env bats

setup_file() {
  export BATS_SHOW_DOCKER_COMMAND=0

  rebash
  . "${BATS_TOP}/tests/helpers/bin::shell.bash"

  local basename
  basename="$(bats::basename)"
  case "${basename}" in
    3*alpine) IMAGE="python:${basename}" ;;
    alpine*|bash*) IMAGE="${basename}" ;;
  esac
  export IMAGE
}

@test "posix-busybox ${IMAGE} ash plain" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c plain" { assert_container; }
@test "posix-busybox ${IMAGE} ash plain ash" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c plain ash" { assert_container; }
@test "failure ${IMAGE} ash plain busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} ash -c plain busybox" { assert_container 'applet not found'; }
@test "posix-busybox ${IMAGE} ash plain sh" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c plain sh" { assert_container; }

@test "failure ${IMAGE} busybox plain" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c plain" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox plain ash" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c plain ash" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox plain busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c plain busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox plain sh" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c plain sh" { assert_container 'applet not found'; }

@test "posix-busybox ${IMAGE} sh plain" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c plain" { assert_container; }
@test "posix-busybox ${IMAGE} sh plain ash" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c plain ash" { assert_container; }
@test "failure ${IMAGE} sh plain busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} sh -c plain busybox" { assert_container 'applet not found'; }
@test "posix-busybox ${IMAGE} sh plain sh" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c plain sh" { assert_container; }

@test "posix-busybox ${IMAGE} ash shebang" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c shebang" { assert_container; }
@test "posix-busybox ${IMAGE} ash shebang ash" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c shebang ash" { assert_container; }
@test "failure ${IMAGE} ash shebang busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} ash -c shebang busybox" { assert_container 'applet not found'; }
@test "posix-busybox ${IMAGE} ash shebang sh" { assert_container; }
@test "posix-busybox ${IMAGE} ash -c shebang sh" { assert_container; }

@test "failure ${IMAGE} busybox shebang" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c shebang" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox shebang ash" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c shebang ash" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox shebang busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c shebang busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox shebang sh" { assert_container 'applet not found'; }
@test "failure ${IMAGE} busybox -c shebang sh" { assert_container 'applet not found'; }

@test "posix-busybox ${IMAGE} sh shebang" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c shebang" { assert_container; }
@test "posix-busybox ${IMAGE} sh shebang ash" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c shebang ash" { assert_container; }
@test "failure ${IMAGE} sh shebang busybox" { assert_container 'applet not found'; }
@test "failure ${IMAGE} sh -c shebang busybox" { assert_container 'applet not found'; }
@test "posix-busybox ${IMAGE} sh shebang sh" { assert_container; }
@test "posix-busybox ${IMAGE} sh -c shebang sh" { assert_container; }
