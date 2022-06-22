# shellcheck shell=bash

export PATH="${BATS_TOP}/tests/fixtures/cd.sh:${PATH}"

bats::remote

export GIT_DIRECTORY="${BATS_REMOTE[0]}/directory"
export OUTPUT_FAILURE="top: "
mkdir -p "${GIT_DIRECTORY}"
OUTPUT_SUCCESS="${OUTPUT_FAILURE}$(cd "${GIT_DIRECTORY}" || return 1; . cd.sh && cd_top && echo "${CD_TOP}")"
export OUTPUT_SUCCESS
