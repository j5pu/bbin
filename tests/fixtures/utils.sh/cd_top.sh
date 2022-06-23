#!/bin/sh

. utils.sh

main() {
  cd_top
  echo "top: ${GIT_TOP}"
}

main "$@"
