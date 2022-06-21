#!/usr/bin/env bats

vars() {
  has docker || skip "Docker daemon not installed"

  for var in DOCKER_HUB_TOKEN GH_TOKEN GIT; do
    [ "${!var-}" ] || skip "Missing ${var}"
  done

  docker-running || >&3 echo "Docker daemon starting"
}

teardown_file() {
  if has docker && [ "${CONTEXT}" != "${LAST_CONTEXT}" ]; then
    docker context use "${CONTEXT}"
  fi
}

@test "$(bats::basename) " {
  vars

  bats::success

  for i in https://index.docker.io/v1/ https://index.docker.io/v2/ https://registry-1.docker.io/v2/ ghcr.io; do
    run docker login "$i"
    assert_success
  done
}

@test "$(bats::basename) foo " {
  vars

  bats::run
  assert_failure
  assert_output --regexp "context \"foo\": not found"
}

@test "assert::helps login to Docker registry and GitHub docker registry" {
  bats::success
}
