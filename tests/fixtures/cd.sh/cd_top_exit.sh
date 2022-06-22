#!/bin/sh

. cd.sh

main() {
  cd_top_exit
  echo "top: ${CD_TOP}"
}

main "$@"
