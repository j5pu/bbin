#!/usr/bin/env bats

setup_file() {
  export BATS_SHOW_DOCKER_COMMAND=0

  rebash
  . "${BATS_TOP}/tests/helpers/bin::shell.bash"

  local basename
  basename="$(bats::basename)"
  case "${basename}" in
    zsh*) IMAGE="zshusers/${basename}" ;;
  esac
  export IMAGE
}

@test "zsh ${IMAGE} zsh plain" { assert_container; }
@test "posix-dash ${IMAGE} zsh -c plain" { assert_container; }
@test "bash-4 ${IMAGE} zsh plain bash" { assert_container; }
@test "bash-4 ${IMAGE} zsh -c plain bash" { assert_container; }
@test "zsh ${IMAGE} zsh plain zsh" { assert_container; }
@test "zsh ${IMAGE} zsh -c plain zsh" { assert_container; }
@test "zsh ${IMAGE} sh plain zsh" { assert_container; }
@test "zsh ${IMAGE} sh -c plain zsh" { assert_container; }

@test "zsh ${IMAGE} zsh shebang" { assert_container; }
@test "posix-dash ${IMAGE} zsh -c shebang" { assert_container; }
@test "bash-4 ${IMAGE} zsh shebang bash" { assert_container; }
@test "bash-4 ${IMAGE} zsh -c shebang bash" { assert_container; }
@test "zsh ${IMAGE} zsh shebang zsh" { assert_container; }
@test "zsh ${IMAGE} zsh -c shebang zsh" { assert_container; }
@test "zsh ${IMAGE} sh shebang zsh" { assert_container; }
@test "zsh ${IMAGE} sh -c shebang zsh" { assert_container; }
