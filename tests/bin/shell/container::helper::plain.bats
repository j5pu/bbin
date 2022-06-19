#!/usr/bin/env bats

setup_file() { rebash; . "${BATS_TOP}/tests/helpers/bin::shell.bash"; }

lib() { "$@" ". ./lib/shell.sh; echo \$SH"; }

@test "alpine posix-busybox ash -c" { shell; }
