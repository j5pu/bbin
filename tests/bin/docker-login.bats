#!/usr/bin/env bats

@test "$(bats::basename) " {
  has docker || skip "Docker daemon not installed"

  if ! docker-running; then
    >&3 echo "Docker daemon starting"
    bats::run
    assert_success
  fi

  run docker-running
  assert_success
}

@test "assert::helps login to Docker registry and GitHub docker registry" {
  bats::success
}
