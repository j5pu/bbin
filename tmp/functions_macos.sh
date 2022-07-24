# macOS disk1 free
df_macos() { df -H | awk '/\/dev\/disk1s1/ { printf $4 }'; }
# file extension if . otherwise empty
# extension /hola.xz/example.tar.gz
# extension /hola.xz/example
extension() { echo "${1##*/}" | awk -F "." '/\./ {print $NF}'; }
# added to $2 (does not show empty files)
files_added() { git diff --diff-filter=A --name-only --no-index "$1" "$2"; }
# deleted in $2 (does not show empty files)
files_deleted() { git diff --diff-filter=D --name-only --no-index "$1" "$2"; }
# removed in $2
files_modified() { git diff --diff-filter=M --name-only --no-index "$1" "$2"; }
# total du for directory/ies or cwd
du_total() { du -hs "$@"; }
# enable smb macOS
enable_sharing() {
  killall System\ Preferences
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk
  test $# -eq 0 || sudo sharing -a "$@"
}
# size of files found in $1
size() { find . -type f -name "${*}" -exec stat -f '%z' "{}" \;; }
# file stem
# stem /hola.xz/example.tar.gz
# stem /hola.xz/example
stem() { echo "${1##*/}" | sed -e 's/\.[^\.]*$//'; } 
# temp function to move to bbin
to_bbin() { git add . && git commit --quiet  -m "moved to bbin $*" && git push --quiet; git status; }
complete -r brctl 2>/dev/null || true
eval "$(zoxide init bash)"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export HOMEBREW_BUNDLE_FILE="${HOME}/bbin/Brewfile"

# JULIA - JUDICIAL
attachments() {
  local file
  while read -r file; do
    echo "$file"
  done < <(find "${HOME}/Library/Mail/V9" -path "*/Attachments/*" -type f)
}
download() { 
  local dir
  dir="$(realpath "${1:-.}")"
#  find -L "${dir}" -type d -exec brctl download "{}" \;
  find -L "${dir}" -type f -name "*.icloud" -exec brctl download "{}" \;
}
evict() {
  local dir
  dir="$(realpath "${1:-.}")" 
  find -L "${dir}" -type d -exec brctl evict "{}" \;
  find -L "${dir}" -type f -not -name "*.icloud" -not -name ".DS_Store" -exec brctl evict "{}" \;
}
preserve() { rsync -aptvADENUX --exclude "*.icloud" "$@"; }
status() {
  local i status x total
  status="$(brctl status com.apple.CloudDocs)"
  status_show() { echo "${3-}${1}: $(grep -- "$2" <<< "${status}" | wc -l)" ; }
  for i in apply downloader reader sync-up upload; do
    status_show "${i}" "> ${i}{"
    case "${i}" in
      apply) 
        for x in pending-download pending-parent; do
          status_show "${x}" "${x}" "  "
        done
        echo "--------------------------------"
        ;;
      downloader) 
        for x in pending-disk; do
          status_show "${x}" "${x}" "  "
        done
        ;;
      reader)
        status_show "needs-read[lost]" "needs-read" "  "
        ;; 
      sync-up) 
        for x in sync-up-scheduled; do
          status_show "${x}" "${x}" "  "
        done
        ;;
      upload) 
        for x in needs-sync-up needs-upload; do
          status_show "${x}" "${x}" "  "
        done
        ;;
    esac
  done
  echo "--------------------------------"
  total "${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
  unset -f status_show
}
total() {
  local dir total
  dir="$(realpath "${1:-.}")"
  total="$(find -L "${dir}" -not -name ".DS_Store" -type f)"
  du -L -h -d1 "${dir}"
  echo
  echo "Total:        $(wc -l <<< "${total}")"
  echo "  evicted:    $(wc -l < <(grep ".icloud$" <<< "${total}"))"
  echo "  downloaded: $(wc -l < <(grep -v ".icloud$" <<< "${total}"))"
}
