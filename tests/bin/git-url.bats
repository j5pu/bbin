#!/usr/bin/env bats

setup_file() {
  . "${BATS_TOP}/tests/helpers/helpers.bash"
  export OCTOCAT="octocat/Hello-World"
  export HELLO="https://github.com/${OCTOCAT}";
  DEFAULT_HELLO="$(git default "${HELLO}")"; export DEFAULT_HELLO
}

@test "$(bats::basename) " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git"; }

@test "$(bats::basename) --git " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git"; }

@test "$(bats::basename) origin" {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) origin --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) origin --git --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) --insteadOf " {
  skip::if::not::var GIT
  bats::success
  assert_output --regexp ".*${GIT}/${BATS_BASENAME}.*";
}

@test "$(bats::basename) origin --insteadOf " {
  skip::if::not::var GIT
  bats::success
  assert_output --regexp ".*${GIT}/${BATS_BASENAME}.*";
}

@test "$(bats::basename) --insteadOf --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output --regexp ".*${GIT}/${BATS_BASENAME}.*";
}

@test "git -C '${PWD}' url origin --insteadOf --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output --regexp ".*${GIT}/${BATS_BASENAME}.*";
}

@test "$(bats::basename) origin --raw " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://raw.githubusercontent.com/${GIT}/${BATS_BASENAME}/$(git default)";
}

@test "$(bats::basename) origin --insteadOf --ping " {
  skip::if::not::var GIT
  bats::success
  assert_output --regexp ".*${GIT}/${BATS_BASENAME}.*";
}

@test "$(bats::basename) origin --insteadOf --ping --ssh " {
  skip::if::not::var GIT
  bats::failure
  assert_output "$(bats::basename): --ssh, --insteadOf: only one format can be provided";
}

@test "$(bats::basename) origin https:// --insteadOf --ping " {
  skip::if::not::var GIT
  bats::failure
  assert_output "$(bats::basename): https://, origin: only one argument can be provided <remote>|<owner/repo>|<url>";
}

@test "$(bats::basename) remote --insteadOf --ping " {
  skip::if::not::var GIT
  bats::failure
  assert_output --regexp "$(bats::basename): ${PWD}: remote: invalid remote";
}

@test "$(bats::basename) --file " {
  skip::if::not::var GIT
  bats::success
  assert_output "git+file://j5pu/bbin";
}

@test "$(bats::basename) --https " {
  skip::if::not::var GIT
  bats::success
  assert_output "git+https://github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) --pip " {
  skip::if::not::var GIT
  bats::success
  assert_output "git+ssh://git@github.com/${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) --ssh " {
  skip::if::not::var GIT
  bats::success
  assert_output "git@github.com:${GIT}/${BATS_BASENAME}.git";
}

@test "$(bats::basename) --web " {
  skip::if::not::var GIT
  bats::success
  assert_output "https://github.com/${GIT}/${BATS_BASENAME}";
}

@test "$(bats::basename) ${HELLO} " {
  bats::success
  assert_output "${BATS_ARRAY[1]}.git"
}

@test "$(bats::basename) ${HELLO}.git " {
  bats::success
  assert_output "${BATS_ARRAY[1]}"
}

@test "$(bats::basename) ${HELLO}.git --ping " {
  bats::success
  assert_output "${BATS_ARRAY[1]}"
}

@test "$(bats::basename) --file ${HELLO}.git " {
  bats::success
  assert_output "git+file://octocat/Hello-World"
}

@test "$(bats::basename) --git ${HELLO}.git " {
  bats::success
  assert_output "${BATS_ARRAY[2]}"
}

@test "$(bats::basename) --https ${HELLO}.git " {
  bats::success
  assert_output "git+${BATS_ARRAY[2]}"
}

@test "$(bats::basename) --pip ${HELLO}.git " {
  bats::success
  assert_output "git+ssh://git@github.com/octocat/Hello-World.git"
}

@test "$(bats::basename) --raw ${HELLO}.git " {
  bats::success
  assert_output "https://raw.githubusercontent.com/${OCTOCAT}/${DEFAULT_HELLO}"
}

@test "$(bats::basename) --ssh ${HELLO}.git --ping " {
  bats::success
  assert_output "git@github.com:octocat/Hello-World.git"
}

@test "$(bats::basename) --web ${HELLO}.git " {
  bats::success
  assert_output "${HELLO}"
}

@test "$(bats::basename) --insteadOf ${HELLO}.git --ping " {
  bats::failure
  assert_output "$(bats::basename): ${BATS_ARRAY[1]}: cannot be used with a path"
}

@test "$(bats::basename) --file ${HELLO}.git --ping " {
  bats::failure
  assert_output "$(bats::basename): --ping: can only be used with --git|--insteadOf|--ssh"
}

@test "$(bats::basename) https://github.com/octocat/foo.git --ping " {
  bats::failure
  assert_output - <<EOF
remote: Repository not found.
fatal: repository '${BATS_ARRAY[1]}/' not found
EOF
}

@test "$(bats::basename) ${OCTOCAT} " {
  bats::success
  assert_output "${HELLO}.git"
}

@test "$(bats::basename) ${OCTOCAT} --ping " {
  bats::success
  assert_output "${HELLO}.git"
}

@test "$(bats::basename) --file ${OCTOCAT} " {
  bats::success
  assert_output "git+file://octocat/Hello-World"
}

@test "$(bats::basename) --git ${OCTOCAT} " {
  bats::success
  assert_output "${HELLO}.git"
}

@test "$(bats::basename) --https ${OCTOCAT} " {
  bats::success
  assert_output "git+${HELLO}.git"
}

@test "$(bats::basename) --pip ${OCTOCAT} " {
  bats::success
  assert_output "git+ssh://git@github.com/octocat/Hello-World.git"
}

@test "$(bats::basename) --raw ${OCTOCAT} " {
  bats::success
  assert_output "https://raw.githubusercontent.com/${OCTOCAT}/${DEFAULT_HELLO}"
}

@test "$(bats::basename) --ssh ${OCTOCAT} --ping " {
  bats::success
  assert_output "git@github.com:octocat/Hello-World.git"
}

@test "$(bats::basename) --web ${OCTOCAT} " {
  bats::success
  assert_output "${HELLO}"
}

@test "$(bats::basename) --insteadOf ${OCTOCAT} --ping " {
  bats::failure
  assert_output "$(bats::basename): ${BATS_ARRAY[1]}: cannot be used with a path"
}

@test "$(bats::basename) --file ${OCTOCAT} --ping " {
  bats::failure
  assert_output "$(bats::basename): --ping: can only be used with --git|--insteadOf|--ssh"
}

