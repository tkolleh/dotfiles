#! /usr/bin/env bash
#
# =============================================================================
#
# symlinked to /usr/local/bin/<filename>
#

#/ Usage: rumount [options] [dir]
#/
#/    -h, --help        show help text
#/     [dir]            Mounted directory to be unmounted
#/
#/ Creates folder on local system and mounts the specififed remote
#/ filesystem to the folder. Inspired by Brett Terpstra's [source code]
#/ (https://github.com/ttscoff/dotfiles/blob/115e89fbac2391058364981ac83da85af79053b7/.bash_profile)
#/
#/
#/ Examples
#/
#/   rmount ml:/home/ubuntu/fma-ws
#/   # => 'mounted ~/mounts/fma-ws'
#/
#/ Returns the exit code of the sshfs command or an exit code of 1.

local host folder mname

while test "$#" -ne 0; do
  case "$1" in
  -h | --help)
    grep '^#/' <"$0" | cut -c4-
    exit 0
    ;;
  -*)
    printf "error: invalid option '%s'\n" "$1" >&2
    exit 1
    ;;
  esac
done

host="${1%%:*}:"
[[ ${1%:} == ${host%%:*} ]] && folder='' || folder=${1##*:}
if [[ $2 ]]; then
  mname=$2
else
  mname=${folder##*/}
  [[ "$mname" == "" ]] && mname=${host%%:*}
fi
if [[ $(grep -i "host ${host%%:*}" ~/.ssh/config) != '' ]]; then
  mkdir -p ~/mounts/$mname >/dev/null
  sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=$mname,noappledouble && echo "mounted ~/mounts/$mname"
else
  echo "No entry found for ${host%%:*}"
  return 1
fi
