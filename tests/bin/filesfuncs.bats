#!/usr/bin/env bats.bash

@test "$(bats::basename) \"$(command -v profile)\" " {
  bats::run
  assert_output - <<EOF
export_funcs_all
export_funcs_path
export_funcs_public
has
history_prompt
path_add
path_add_exist
path_add_exist_all
path_append
path_append_exist
path_dedup
path_in
path_pop
pwd_p
rebash
source_dir
EOF
}

@test "$(bats::basename) \"$(command -v bats.bash)\" " {
  bats::run
  refute_line _help
  assert_line bats::tmp
}
