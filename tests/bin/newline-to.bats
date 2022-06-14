#!/usr/bin/env bats

@test "$(bats::basename) \"\$(printf '%s\n' 1 \"2 2\" 3)\"" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_output '^1$|^2 2$|^3$'
}

@test "$(bats::basename) 1 '2 2' 3 '*:'" {
  run "$(bats::basename)" "$(printf '%s\n' 1 "2 2" 3)" '*:'
  assert_output '1*:2 2*:3'
}

@test "$(bats::basename) \"\$(printf '%s\n' 1 \"2 2\" 3)\" '*:'" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_output '1*:2 2*:3'
}

@test "echo \"/bin:/usr/bin:\" | tr ':' '\n' | $(bats::basename) :" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_output /bin:/usr/bin
}

@test "printf '%s\n' 1 \"2 2\" 3 | $(bats::basename) '|'" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_output '1|2 2|3'
}

@test "$(bats::basename) \"\$(printf '%s\n' 1 \"2 2\" 3)\" '|'" {
  run sh -c "${BATS_TEST_DESCRIPTION}"
  assert_output '1|2 2|3'
}
