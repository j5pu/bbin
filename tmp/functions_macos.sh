# macOS disk1 free
df_macos() { df -H | awk '/\/dev\/disk1s1/ { printf $4 }'; }
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
# temp function to move to bbin
to_bbin() { git add . && git commit --quiet  -m "moved to bbin $*" && git push --quiet; git status; }
complete -r brctl 2>/dev/null || true
eval "$(zoxide init bash)"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

# JULIA - JUDICIAL
download() { find -L "$(realpath "${1:-.}")" -type f -name "*.icloud" -exec brctl download "{}" \;; }
evict() { find -L "$(realpath "${1:-.}")" -type f -not -name "*.icloud" -not -name ".DS_Store" -exec brctl evict "{}" \;; }
preserve() { rsync -aptvADENUX "$@"; }

