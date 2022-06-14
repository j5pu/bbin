#!/usr/bin/env bats.bash

@test "filefuncs \"$(command -v paths.sh)\" " {
  bats::run
  assert_output - <<EOF
path_add
path_add_exist
path_add_exist_all
path_append
path_append_exist
path_dedup
path_in
path_pop
EOF
}

@test "filefuncs \"$(command -v bats.bash)\" " {
  bats::run
  refute_line _help
  assert_line bats::tmp
}
