show_help() {
  echo
  echo -e "\e[1mcottonfetch 1.11 installer\e[0m"
  echo "created by servalx4"
  echo
  echo "usage:"
  echo "  cfetch-install             install cottonfetch"
  echo "  cfetch-install -d <dir>    install cottonfetch to directory"
  echo "  cfetch-install --help      show this message"
  echo
  echo "thank you for using cottonfetch <3"
  echo
}

[[ $* == *--help* ]] && show_help && exit 0

# colors
declare -A C=(
  [nc]='\e[0m' [blk]='\e[0;30m' [dgr]='\e[1;30m'
  [red]='\e[0;31m' [lrd]='\e[1;31m'
  [grn]='\e[0;32m' [lgr]='\e[1;32m'
  [ylw]='\e[1;33m' [org]='\e[0;33m'
  [blu]='\e[0;34m' [lbl]='\e[1;34m'
  [prp]='\e[0;35m' [lpr]='\e[1;35m'
  [cyn]='\e[0;36m' [lcy]='\e[1;36m'
  [wht]='\e[1;37m' [lgy]='\e[0;37m'
)
blink='\033[5m' # thanks, pancoreon!
user="$(whoami)"
shebang="#!$(which bash 2>/dev/null)"
busybox="$(which busybox 2>/dev/null)"

echo
echo "cottonfetch 1.11 installer"
echo

directory="/usr/bin/" # default

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--directory)
      directory="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
! [ -d "$directory" ] && echo -e "${C[red]}error:${C[nc]} invalid directory." && exit 2
touch "$directory"/tmpfile 2>/dev/null
if ! [ -f "$directory"/tmpfile ]; then
  echo -e "${C[red]}error:${C[nc]} user has no write permission in directory $directory." && exit 1
fi
rm "$directory"/tmpfile 2>/dev/null

missing_critical=""
missing_file=""
missing=""
missing_opt=""
success="1"

critical_deps=(bash lspci cut tail head grep xargs uname whoami)
critical_dep_fs=(/proc/cpuinfo /proc/meminfo)
deps=(glxinfo df uptime xrandr)
opt_deps=(wlr-randr swaymsg)

for cmd in "${critical_deps[@]}"; do
    if ! which "$cmd" >/dev/null 2>&1; then
        missing_critical+="$cmd "
    fi
done
for dir in "${critical_dep_fs[@]}"; do
    if ! [[ -f $dir ]]; then
        missing_file+="$dir "
    fi
done
for cmd in "${opt_deps[@]}"; do
    if ! which "$cmd" >/dev/null 2>&1; then
        missing_opt+="$cmd "
    fi
done

if [ -n "$missing_critical" ]; then
    echo -e "${C[red]}missing critical deps:${C[nc]} $missing_critical"
    exit 3
fi
if [ -n "$missing_file" ]; then
    echo -e "${C[red]}missing critical files:${C[nc]} $missing_file"
    exit 4
fi
if [ -n "$missing" ]; then
    echo -e "${C[red]}missing deps:${C[nc]} $missing"
    echo "installation of these is reccomended, critical information might be unavailable!"
    success="0"
fi
if [ -n "$missing_opt" ]; then
    echo -e "${C[ylw]}optional deps:${C[nc]} $missing_opt"
    echo "installation of these is optional, some information might be unavailable."
fi
if [ -n "$busybox" ]; then
    echo -e "${C[red]}WARNING!!!${C[nc]}"
    echo -e "it appears you are using ${C[wht]}busybox{C[nc]} which heavily breaks cottonfetch (at least at the moment)!"
    echo -e "functionality is NOT guaranteed!"
    success="0"
fi
echo
echo "$shebang" > cottonfetch
cat cottonfetch-base >> cottonfetch
chmod +x cottonfetch
mv cottonfetch "$directory"
if [ -f "$directory"/cottonfetch ]; then
    if [[ $success == "1" ]]; then
        echo -e "${C[grn]}installation completed successfully!${C[nc]}"
    else
        echo -e "${C[ylw]}installation completed, errors reported.${C[nc]}"
    fi
fi
echo "NOTE: this script is intended to be modified. don't like how the output looks? edit info(). don't like the ascii art? edit ascii()."
echo "is cottonfetch being really slow? consider commenting out get_pkg_count, most likely the culprit. don't forget to remove package count in info(), or it'll just be empty."
