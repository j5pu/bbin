#!/usr/bin/env bats

@test "$(bats::basename) " {
  if docker version 2>&1 | grep -q "Is the docker daemon running"; then
    bats::failuree
  elif has docker; then
    bats::success
  else
    skip "Docker daemon not installed"
  fi
}

@test "assert::helps is Docker daemon running?" {
  bats::success
}
