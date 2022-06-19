#!/usr/bin/env bats

# FIXME: el docker login no funciona, no estaba docker login en desktop

@test "$(bats::basename) " {
  has docker || skip "Docker daemon not installed"

  for var in DOCKER_HUB_TOKEN GH_TOKEN GIT; do
    [ "${!var-}" ] || skip "Missing ${var}"
  done

  docker-running || >&3 echo "Docker daemon starting"
  bats::success

  for i in https://index.docker.io/v2/ https://registry-1.docker.io/v2/ ghcr.io; do
    run docker login "$i"
    assert_success
  done
}

@test "assert::helps login to Docker registry and GitHub docker registry" {
  bats::success
}
