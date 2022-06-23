#!/bin/sh

. utils.sh

main() {
  cd_top
  echo "top: ${CD_TOP}"
}

main "$@"
