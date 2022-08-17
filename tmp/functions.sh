# shellcheck shell=bash disable=SC2043,SC2181

#######################################
# macOS disk1 free
# Arguments:
#  None
#######################################
df_macos() { df -H | awk '/\/dev\/disk1s1/ { printf $4 }'; }

#######################################
# file extension if has . on filename otherwise empty
# Arguments:
#   1
# Examples:
#   extension /hola.xz/example.tar.gz
#   extension /hola.xz/example
#######################################
extension() { echo "${1##*/}" | awk -F "." '/\./ {print $NF}'; }

#######################################
# show files added to $2 directory not in $1 directory (does not show empty files)
# Arguments:
#   1
#   2
#######################################
files_added() { git diff --diff-filter=A --name-only --no-index "$1" "$2"; }

#######################################
# show files deleted in $2 directory which where in $1 directory (does not show empty files)
# Arguments:
#   1
#   2
#######################################
files_deleted() { git diff --diff-filter=D --name-only --no-index "$1" "$2"; }

#######################################
# show files modified/changed in two directory (not deleted or added)
# Arguments:
#   1
#   2
#######################################
files_modified() { git diff --diff-filter=M --name-only --no-index "$1" "$2"; }

#######################################
# total du for directory/ies or cwd
# Arguments:
#  None
#######################################
du_total() { du -hs "$@"; }

#######################################
# enable smb macOS
# Arguments:
#  None
#######################################
enable_sharing() {
  killall System\ Preferences
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk
  test $# -eq 0 || sudo sharing -a "$@"
}

#######################################
# show percentage of $1 from $2 total with $3 decimals (default: 2)
# Arguments:
#   1   value
#   2   total
#   3   extra message
#######################################
outof() { echo -e "\e[32m${1}\e[0m/\e[32m${2} \e[34m$(percentage "$1" "$2")\e[0m%${3:+ $3}"; }

#######################################
# percentage of $1 from $2 total with $3 decimals (default: 2)
# Arguments:
#   1   value
#   2   total
#   3   number of decimals (default: 2)
#######################################
percentage() { awk "BEGIN{printf \"%.${3:-2}f\n\",${1}/${2}*100}"; }

#######################################
# list of files size found in directory
# Arguments:
#  None
#######################################
size() { find . -type f -name "${*}" -exec stat -f '%z' "{}" \;; }

#######################################
# file stem
# Arguments:
#   1
# Examples:
#   stem /hola.xz/example.tar.gz
#   stem /hola.xz/example
#######################################
stem() { echo "${1##*/}" | sed -e 's/\.[^\.]*$//'; }

#######################################
# directories excluded from time machine
# Arguments:
#  None
#######################################
timemachine_excluded() { sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"; }

#######################################
# removes exclusion in time machine, it will be backed up again
# Arguments:
#  None
#######################################
timemachine_remove_excluded() { sudo tmutil removeexclusion "$@"; }

# temp function to move to bbin
to_bbin() {
  git add . && git commit --quiet -m "moved to bbin $*" && git push --quiet
  git status
}

complete -r brctl 2>/dev/null || true
eval "$(zoxide init bash)"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export HOMEBREW_BUNDLE_FILE="${HOME}/bbin/Brewfile"

# JULIA - JUDICIAL

#######################################
# Copy Mail attachments and remove duplicates
# Globals:
#   HOME
# Arguments:
#   1
#   2
#######################################
attachments() {
  local copy dir=/Volumes/USB-2TB/Attachments extension file sum
  # copy
  copy() {
    ! test -f "$2" && cp -pv "$1" "$2"
  }
  while read -r file; do
    extension="$(extension "${file}")"
    test -s "${file}" || continue
    [ "$(stat -f "%z" "${file}")" -ne 0 ] || continue
    if ! copy "${file}" "${dir}/${file##*/}"; then
      sum="$(md5sum "${file}" | awk '{ print $1 }')"
      if ! find "${dir}" -type f -exec md5sum "{}" \; | awk '{ print $1 }' | grep -q "${sum}"; then
        copy "${file}" "${dir}/$(stem "${file}") (${sum})${extension:+.${extension}}"
      fi
    fi
  done < <(find "${HOME}/Library/Mail/V9" -path "*/Attachments/*" -type f)
  unset -f copy
}

#######################################
# copy audios from iCloud and text
# Arguments:
#  None
#######################################
audios() {
  local c=0 dir dest files readable='@' src suffix="pdf" total
  dir="/Volumes/USB-2TB/Documents/Julia/Backups - Audios - Sacadas Ordenador - \
Capturas Pantalla /Audios y Transcripciones/Mio"
  files="$(find "${dir}" -type f -iname "*.m4a"  | sort -R)"
  total="$(echo "${files}" | wc -l | sed 's/ //g')"

  while read -r src; do
    ((c += 1))
    suffix="$(extension "${src}")"
    dest="${src%/*}/$(basename "${src}" ".${suffix}")${readable}.${suffix/m4a/txt}"
    if ! test -f "${dest}" || [ "${src}" -nt "${dest}" ]; then
      echo "${dest}"
      ~/Tools/hear/products/hear --language es-ES -i "${src}" >"${dest}"
      file="  \e[32m${src}\e[0m"
      [ $? -eq 0 ] || file="  \e[31m${src}\e[0m"
      outof "${c}" "${total}" "${file}"
    fi
  done <<<"${files}"
}

#######################################
# description
# Arguments:
#  None
#######################################
audio() {
  local dir file
  dir="/Volumes/USB-2TB/Documents/Julia/Backups - Audios - Sacadas Ordenador - \
Capturas Pantalla /Audios y Transcripciones/Mio"

  while read -r file; do
    echo Starting: "${file}" "${file/.m4a/@.txt}"
    test -f "${file/.m4a/@.txt}" || ~/Tools/hear/products/hear --language es-ES -i "${file}" > "${file/.m4a/@.txt}"
  done < <(find "${dir}" -type f -name "*.m4a")
}

#######################################
# description
# Arguments:
#  None
#######################################
ocrall() {
  local i
  while read -r i; do
    ocr "" &
  done < <(seq )
}

#######################################
# source .bashrc
# Globals:
#   HOME
# Arguments:
#  None
#######################################
bashrc() { . "${HOME}/.bashrc"; }

#######################################
# sort files by date in documents and create PDF
# Globals:
#   HOME
# Arguments:
#   1
#######################################
dates() {
  local dir file keys tmp files
  dir="${HOME}/Documents/Julia"
  declare -A files
  while read -r file; do
    ! echo "${file##*/}" | grep -q -- " -" || files["${file##*/}"]="${file}"
  done < <(find "${dir}" -type f -name "20*" | sed "s|${dir}/||g")
  keys="$(printf "%s\n" "${!files[@]}" | sort)"
  # create file
  to_file() {
    tmp="$(mktemp)"
    rm -f "$1"
    while read -r file; do
      echo "${file} ${files[${file}]}" >>"${tmp}"
    done <<<"${keys}"
    cupsfilter -o landscape "${tmp}" >"$1"
  }
  tmp="$(mktemp)"
  echo "${keys}" >"${tmp}"
  cupsfilter -o landscape "${tmp}" >"${dir}/LISTA.pdf"
  to_file "${dir}/LISTA_TODOS.pdf"
  keys="$(echo "${keys}" | grep JUZGADO)"
  to_file "${dir}/LISTA_JUZGADO.pdf"
}

#######################################
# iCloud download directory
# Arguments:
#   1
#######################################
download() {
  local dir
  dir="$(realpath "${1:-.}")"
  #  find -L "${dir}" -type d -exec brctl download "{}" \;
  find -L "${dir}" -type f -name "*.icloud" -exec brctl download "{}" \;
}

#######################################
# iCloud evict directory
# Arguments:
#   1
#######################################
evict() {
  local dir
  dir="$(realpath "${1:-.}")"
  find -L "${dir}" -type d -exec brctl evict "{}" \;
  find -L "${dir}" -type f -not -name "*.icloud" -not -name ".DS_Store" -exec brctl evict "{}" \;
}

#######################################
# pdf, png and jpeg ocr directory
# Arguments:
#   1
#######################################
ocr() {
  local c=0 dir dest files log readable='@' src suffix="pdf" total
  dir="$(realpath "${1:-/Volumes/USB-2TB/Documents/Julia}")"
  files="$(find "${dir}" -type f \
    \( -iname "*.pdf" -or -iname "*.png" -or -iname "*.jpg" \) \
    \( -not -iname "*${readable}.*" -and -not -name "LISTA*" \) | sort -R)"
  log="$(mktemp)"
  total="$(echo "${files}" | wc -l | sed 's/ //g')"

  while read -r src; do
    ((c += 1))
    suffix="$(extension "${src}")"
    dest="${src%/*}/$(basename "${src}" ".${suffix}")${readable}.${suffix/PNG/txt}"
    if ! test -f "${dest}" || [ "${src}" -nt "${dest}" ]; then
      if [ "${suffix}" = "pdf" ]; then
        ocrmypdf -l spa+eng --force-ocr "${src}" "${dest}" 1>"${log}" 2>&1
      else
        easyocr -l es en -f "${src}" >"${dest}" 2>>"${log}"
      fi
      file="  \e[32m${src}\e[0m"
      [ $? -eq 0 ] || file="  \e[31m${src}\e[0m"
      outof "${c}" "${total}" "${file}"
    fi
  done <<<"${files}"

  ! test -s "${log}" || echo "${log}"
  grep "File name too long" "${log}" || true
}

#######################################
# description
# Arguments:
#  None
#######################################
ocrall() {
  local i
  while read -r i; do
    ocr "" &
  done < <(seq 30)
}

#######################################
# rsync directory preserving attrs, permissions and dates
# Arguments:
#  None
#######################################
preserve() { rsync -aptvADENUX --exclude "*.icloud" "$@"; }

#######################################
# brctl status
# Globals:
#   HOME
# Arguments:
#   1
#   2
#   3
#######################################
status() {
  local i status status_show x
  status="$(brctl status com.apple.CloudDocs)"
  # show status
  status_show() { echo "${3-}${1}: $(grep -c -- "$2" <<<"${status}")"; }
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

#######################################
# iCloud total files downloaded and evicted in directory
# Arguments:
#   1
#######################################
total() {
  local dir total
  dir="$(realpath "${1:-.}")"
  total="$(find -L "${dir}" -not -name ".DS_Store" -type f)"
  du -L -h -d1 "${dir}"
  echo
  echo "Total:        $(wc -l <<<"${total}")"
  echo "  evicted:    $(wc -l < <(grep ".icloud$" <<<"${total}"))"
  echo "  downloaded: $(wc -l < <(grep -v ".icloud$" <<<"${total}"))"
}

jet-service
