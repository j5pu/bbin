#!/bin/sh

. cd.sh

main() {
  cd_top
  echo "top: ${CD_TOP}"
}

main "$@"
