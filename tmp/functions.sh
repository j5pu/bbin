# shellcheck shell=bash disable=SC2043,SC2181
alias ls="lsd"

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
extension() { echo "${1##*/}" | awk -F "." '/\./ { print $NF }'; }

#######################################
# show files added to $2 directory not in $1 directory (does not show empty files)
# Arguments:
#   1
#   2
#######################################
files_diff() {
  find "$1" "$2" -type f -name ".DS_Store" -delete;
  git diff --name-only --no-index "$1" "$2"; diff "$1" "$2";
}

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
preserve() { rsync -avAXUN E --exclude "*.icloud" "$@"; }
#######################################
# description
# Arguments:
#  None
#######################################
dry() { preserve -n "$@"; }

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

#######################################
# description
# Arguments:
#  None
#######################################
video() {
  local i dest="/Volumes/USB-2TB/Recovered/Windows/converted - video"
  mkdir -p "${dest}"
  while read -r i; do
    ffmpeg -nostdin -y -i "$i" "${dest}/$(stem "$i")".mp4 &
    sleep 3
  done < <(find "/Volumes/USB-2TB/Recovered/Wondershare - DATA/Recoverit 2022-08-19 at 03.20.20/Unsourced files/Video" \
    -type f )
}

#######################################
# Copy Mail attachments and remove duplicates
# Globals:
#   HOME
# Arguments:
#   1
#   2
#######################################
windows() {
  local copy dir=~/Windows/All extension extensions file src=/Volumes/"$1" sum
  extensions="$(cat <<EOF
---
000
001
002
003
004
005
01
02
03
04
05
06
07
08
09
1
10
100
16
2
2005-09-08-02-50-40-0515-00
29
291CE843_86A0_4ED1_B843_C9720B19B025
3
3643236F_FC70_11D3_A536_0090278A1BB8
386
3gp
4
40D5CE2532074296B6DD2138D9286013
5
6
7
7D0F94BE_01EA_437E_ACD5_83E665F9465F
8BF
95
98
A8BA8760_E619_11D3_8F5D_00C04F9CF4AC
AB5E1073_AD9B_48DF_B07F_3E445B5A45CF
ACG
ACL
ACS
AC_
ADHM
ADM
AD_
AN_
API
ASP
AS_
AV_
AW
AX
AX_
BAT
BA_
BDR
BI_
BLD
BM_
BPD
BTL
BTR
CAB
CAT
CA_
CBZ
CDR
CDX
CFS
CF_
CGM
CHM
CHM_3082
CHS
CHT
CH_
CMD
CMP
CM_
CNT
CNV
CNV_3082
CN_
CO_
CP1250
CP1251
CP1253
CP1254
CP1256
CP1257
CPL
CP_
CS_
CTG
CT_
CUR
CU_
CVB
Cat
Cpl
D0DF3458_A845_11D3_8D0A_0050046416B9
DAT
DATA
DA_
DBS
DB_
DEFAULT
DEP
DE_
DIC
DI_
DLL_0001
DLL_0001_3082
DLL_0002
DLL_0004_3082
DLL_0005_3082
DLL_3082
DL_
DOC
DOS
DOT
DO_
DPC
DRV
DR_
DS
DS_
DS_Store
DTD
DT_
DU_
Dat
DeskLink
Dev
ECF
EC_
ELM
ENG
ENU
EN_
EPS
ERR
ESN
ESP
ES_
EXE_0001
EXE_0002_3082
EXE_3082
EXP
EX_
Evt
FAC
FAD473D6_E564_11D3_8F5D_00C04F9CF4AC
FAE
FAM
FDD
FLT
FLT_3082
FMT
FNT
FOT
FO_
FR_
GID
GI_
GP_
GRA
GRD
GR_
H
HDR
HID
HIV
HLP
HL_
HOL
HOL_3082
HTC
HTM_0001
HTT
HT_
HX_
H_
IBT
ICC
ICI
ICM
IC_
ID
IE_
IMD
IME
IMP
IM_
INF
INS
INX
IN_
ISS
IS_
ITS
IT_
JC_
JP_
JSP
JS_
KO_
LDZ
LEX
LE_
LIC
LLD
LNG
LNK
LOC
LST
LUT
LX_
Lcd
LiveSubscribe
LiveUpdate
Lmd
MAN
MAP
MAPIMail
MA_
MB
MB_
MDA
MDA_0001
MDB
MDE
MDI
MDT
MD_
MF_
MID
MI_
MML
MMW
MM_
MOD
MOF
MOF_3082
MOI
MO_
MS950_HKSCS
MSG
MSG_3082
MSI
MST
MS_
MTX
Manifest
Msi
Mtx
N1_
NCS
NEC
NGR
NK2
NLR
NLS
NL_
NSI
NT
NTF
NT_
NVU
Ncs
OB_
OCX_3082
OC_
OFT
OLB
OLD
OPC
OPG
OPS
OS_
PAT
PBK
PCX
PFB
PFM
PGI
PIF
PIP
PI_
PLS
PL_
PNF
PN_
POC
POT
PPD
PPT
PP_
PRT
PR_
PS
PSP
PST
PTS
PUB
PX
Pat
Policy
Prm
Pts
QCP
RA_
REG
RE_
RLL
RLL_1033
RLL_3082
RL_
RO_
RSD
RST
RS_
RT
RTF
RTP
RecordNowSendToExt
SAM
SAM_3082
SA_
SCM
SCP
SC_
SDB
SD_
SET
SE_
SFX
SHP
SH_
SIF
SIG
SI_
SM
SMP
SPM
SP_
SQL
SQ_
SR_
STC
STD
STP
SV_
SWF
SW_
SYD
SYX
SY_
TAG
TA_
TBL
TB_
THD
TH_
TLB
TL_
TMP
TOC
TPL
TP_
TRI
TR_
TSK
TS_
TTF
TT_
TV
TV_
TX_
UC_
UFO
UOL
UPL
URL
UserProfile
V
V01
VA
VAR
VB_
VER
VE_
VSP
VXD
VX_
WA_
WB_
WE_
WFC
WIZ
WJF
WK_
WMF
WM_
WPD
WPG
WP_
WRI
Wiz
X32
XD_
XG0
XG1
XG2
XG3
XG4
XG5
XG6
XG7
XG8
XG9
XLA
XLA_3082
XLL
XLS
XL_
XML
XML_3082
XM_
XSD
XSL
XS_
YG0
YG1
YG2
YG3
YG4
YG5
YG6
YG7
YG8
YG9
ZFSendToTarget
ZIP
ZI_
_
_MP
ab3
access
acl
acm
acrodata
acs
adm
adp
aft
ai
ani
ann
ap0
api
apl
as$
ask
asms
asp
aspx
au
awc
awd
awl
ax
ba2
background
backup
bat
bch
bckp
bcm
bdb
beo
bfc
bif
bitmap
bkg
bla
boot
bpl
bsi
cab
cac
cag
cat
cbo
cbt
cch
ccr
cdx
cer
certs
cf
cf1
chk
chm
chq
chr
chs
cht
chw
cidb
clam
clb
clx
cmd
cn
cn_
cnt
cnv
conf
config
copy
cover
cpi
cpl
cpt
cpx
crmlog
crt
crv
csf
cur
cvr
dap
dat
data
db-journal
dbb
dbf
dbl
dbs
dbx
dcf
dcr
de
def
default
der
deu
dev
dic
dict
diz
dl_
dlg
dls
dmk
dmp
doc
dot
dra
drv
ds
dsb
dsc
dss
dst
dstx
dsx
dtd
dun
dvd
dwr
edb
emf
en
enc
eng
enu
env
esn
ex_
exc
exd
exe -uninstall
exp
exv
fac
fdb
fio
fl
flg
flt
fmt
fo_
fon
for
fpx
fr
fra
frm
fts
fwd
g32
gap
gdb
ggx
gi_
gid
grd
grm
gz
h
hdr
hds
hex
hhk
hi
hid
hiv
hkf
hl_
hlp
hpb
ht1
hta
htc
html
htt
hxx
hyp
ibt
icc
icm
ico
icw
iec
ilg
image
ime
imp
imv
inc
index
inf
inuse
inx
ion
ips
iqy
isp
isu
ita
itc
ithmb
itl
itw
iw
ja
joboptions
jpn
jsa
kc
key
kfg
kit
kml
ko
kor
kpz
kvw
lcd
lck
ldif
ldo
len
lex
lic
liveReg
lng
lnk
lo_
local
lock
lok
lpk
lst
lut
lvr
lxa
manifest
map
mapping
mar
max
mbk
mch
md_
mdb
mdi
mdmp
mdw
mdz
mfl
mgc
mht
mid
mmf
mod
mof
mpp
msc
msg
msi
msn
msp
msstyles
mst
mvb
mydocs
ngr
nl_
nld
nlp
nlr
nls
nms
nok;tile=1;sz=320x55;ord=833573
npl
nsi
ntf
nvu
o32
oad
obe
odc
olb
old
ols
otf
out
pal
pbk
pcb
pcf
pcm
pdef
pdx
pem
pf
pfb
pfm
pfx
phb
php
pif
pip
plist
plup
pmp
policy
pop;niv=0;ga=econ_es;tile=3;sz=1x1;ord=136449
pop;niv=0;ga=econ_es;tile=3;sz=1x1;ord=147112
pop;niv=0;ga=econ_es;tile=3;sz=1x1;ord=213369
pop;niv=0;ga=econ_es;tile=3;sz=1x1;ord=346357
pop;niv=0;ga=econ_es;tile=3;sz=1x1;ord=833573
pot
ppa
ppd
ppp
pps
prc
pref
prefs
prf
pro
properties
prx
ps
psd
psf
psl
psp
pst
ptn
pvk
pyd
qfn
qm
qpa
qtif
qtp
qtr
qts
qtx
query
ram
rar
rat
rbf
rck
ref
reg
req
rgn
rgs
rjt
rll
rm
rng
rnx
rom
rp_
rpd
rpv
rra
rsa
rsf
rsp
rst
rtf
rtp
ru
rul
sam
sav
sca
scf
schema
scp
scr
sdb
sdf
sec
security
sep
sequ
set
shl
shp
shw
sidb
sif
sig
sim
skin
skn
smf
smi
smil
smp
sol
son
spd
spm
sql
sqm
src
srm
srs
sta
state
ste
strings
stt
sty
sve
svg
swf
swp
sy0
sy_
tab
tag
tbl
template
th
tha
theme
thl
thn
thumb
tif
tip
tl_
tlb
tmp
toc
tpl
trace
tri
trm
tsk
tsp
ttc
ttf
tvp
tx_
uce
ucp
uex
ufo
ugl
uninstall
upi
upl
upp
url
usl
usp
var
vbs
vcf
vdm
ver
vft
vfx
vio
vm
vqr
vs
vsdir
vxd
w
w9x
wab
wab~
wb2
wbk
wiz
wk4
wma
wmdb
wme
wmf
wms
wmz
wpc
wpd
wpg
wpl
wvs
x32
x3d
xar
xdc
xdr
xla
xlb
xls
xlt
xml
xpt
xrs
xsd
xsl
xum
zdt
zh
zh_CN_GB18030
zh_TW
zh_TW_MS950_HKSCS
zip
EOF
)"
  # copy
  copy() { ! test -f "$2" && cp -pv "$1" "$2"; }
  while read -r file; do
    extension="$(extension "${file}")"
    [ "${extension-}" ] || continue

    echo "${extensions}" | grep -qi ".${extension}$" && continue
#    test -s "${file}" || continue
#    [ "$(stat -f "%z" "${file}")" -ne 0 ] || continue
#    if ! copy "${file}" "${dir}/${file##*/}"; then
#      sum="$(md5sum "${file}" | awk '{ print $1 }')"
#      if ! find "${dir}" -type f -exec md5sum "{}" \; | awk '{ print $1 }' | grep -q "${sum}"; then
#        copy "${file}" "${dir}/$(stem "${file}") (${sum})${extension:+.${extension}}"
#      fi
#    fi
   echo "${extension}"
  done < <(find "${src}" -type f)
  unset -f copy
}

#######################################
# description
# Arguments:
#  None
#######################################
windows_all() { windows HDD; windows DATA; }

#######################################
# description
# Arguments:
#  None
#######################################
windows_rm() {
  local i
  for i in bak bin cfg class com db dll exe gif htm idx ini jar js log net ocx sys txt; do
    sudo find ~/Windows/All -type f -iname "*.${i}" -delete
  done
}

#######################################
# description
# Arguments:
#  None
#######################################
wma() {
  local i dest="/Volumes/USB-2TB/Recovered/Windows/Music/converted"
  while read -r i; do
    ffmpeg -nostdin -y -i "$i" "${dest}/$(stem "$i")".m4a &
    sleep 3
  done < <(find "/Volumes/USB-2TB/Recovered/Wondershare - DATA/Recoverit 2022-08-19 at 03.20.20/Unsourced files/Audio" \
    -type f )
}

jet-service
export PATH="${HOME}/media/scripts:${HOME}/media/scripts/run:${PATH}"
