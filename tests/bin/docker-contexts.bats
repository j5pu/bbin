#!/usr/bin/env bats

@test "$(bats::basename) " {
  if has docker; then
    bats::success
    assert_line "default"
  else
    skip "Docker daemon not installed"
  fi
}

@test "assert::helps list docker contexts" {
  bats::success
}
