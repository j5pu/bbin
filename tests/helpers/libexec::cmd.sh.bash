# shellcheck shell=bash

export PATH="${BATS_TOP}/tests/fixtures/cd.sh:${PATH}"

bats::remote

export GIT_DIRECTORY="${BATS_REMOTE[0]}/directory"
export OUTPUT_FAILURE="top: "
mkdir -p "${GIT_DIRECTORY}"
OUTPUT_SUCCESS="${OUTPUT_FAILURE}$(cd "${GIT_DIRECTORY}" || return 1; git rev-parse --show-toplevel)"
export OUTPUT_SUCCESS
