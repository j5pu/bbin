#!/usr/bin/env bats

f() { :; }

@test "type $(bats::basename)" {
  bats::run
  assert_output "$(bats::basename) is $(command -v "$(bats::basename)")"
}

@test "$(bats::basename) ls " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename) foo " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename) f " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename) ls cd sudo " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename) ls foo sudo " {
  bats::run
  assert_failure
  assert_output ""
}


@test "type $(bats::basename).sh" {
  bats::run
  assert_output "$(bats::basename).sh is $(command -v "$(bats::basename).sh")"
}

@test "$(bats::basename).sh ls " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename).sh foo " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename).sh f " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename).sh ls cd sudo " {
  bats::run
  assert_success
  assert_output ""
}

@test "$(bats::basename).sh ls foo sudo " {
  bats::run
  assert_failure
  assert_output ""
}

@test "$(bats::basename) sourced " {
  . "$(bats::basename)"
  sourced() { :; }

  bats::run
  assert_success
  assert_output ""
}
