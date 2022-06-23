#!/bin/sh

. utils.sh

main() {
  cd_top_exit
  echo "top: ${GIT_TOP}"
}

main "$@"
