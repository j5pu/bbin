#!/usr/bin/env bats.bash

setup_file() { export HELPS_LINE="list functions in file/files, start at the beginning of the line, function()"; }

@test "$(bats::basename) " { bats::failure; assert_line "${HELPS_LINE}"; }

@test "assert::helps" { bats::success; }

@test "$(bats::basename) \"$(command -v profile.sh)\" " {
  bats::success
  assert_output - <<EOF
export_funcs_all
export_funcs_path
export_funcs_public
has
history_prompt
path_add
path_add_all
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
  bats::success
  refute_line _help
  assert_line bats::tmp
}
