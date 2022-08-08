# shellcheck shell=sh

# External USB storage device mount point
#
export USB="/Volumes/USB-2TB"; test -d "${USB}" || unset USB

export USB_CACHE="${USB:-${HOME-}}/Library/Caches"
export USB_TEMP="${USB:-${TMPDIR-}}/tmp"
