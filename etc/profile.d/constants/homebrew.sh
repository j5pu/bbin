# shellcheck shell=sh

# TODO: move to bin and link here and also el PREFIX y el BREW_FILE....

export HOMEBREW_BAT=1
export HOMEBREW_BUNDLE_FILE="${BBIN_PREFIX}/Brewfile"
export HOMEBREW_CACHE="${USB_CACHE}/Homebrew"
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_FORCE_VENDOR_RUBY=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_PRY=1
export HOMEBREW_TEMP="${USB_TEMP}/Homebrew"


if [ "${BBIN_DEVELOPMENT-0}" -eq 1 ]; then
  export HOMEBREW_CACHE="${HOMEBREW_CACHE}/development"
  export HOMEBREW_TEMP="${HOMEBREW_TEMP}/development"
fi

[ "$(id -u)" -eq 0 ] || mkdir -p "${HOMEBREW_CACHE}" "${HOMEBREW_TEMP}"
