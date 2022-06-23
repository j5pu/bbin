#!/bin/sh

set -eu

. utils.sh

main() {
  cd_top
  echo "top: ${CD_TOP}"
}

main "$@"
