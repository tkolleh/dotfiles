#! /usr/bin/env bash
#
# =============================================================================
#
# symlinked to /usr/local/bin/<filename>
#

#/ Usage: rumount [options] [dir]
#/
#/   -h, --help        show help text
#/   -a, --all         Option to remove all mounted directories at ~/mounts
#/   [dir]            Mounted directory to be unmounted
#/
#/ Unmounts remote directory(s) mounted with rmount and deletes their local
#/ folder. Inspired by Brett Terpstra's [source code](https://github.com/ttscoff/dotfiles/blob/115e89fbac2391058364981ac83da85af79053b7/.bash_profile).
#/
#/
#/ Examples
#/
#/   rumount fma-ws
#/   # => ''
#/
#/ Returns the exti code of the rm command or 0 otherwise.

local _unmount_all

_unmount_all=false

while test "$#" -ne 0; do
  case "$1" in
  -h | --help)
    grep '^#/' <"$0" | cut -c4-
    exit 0
    ;;
  -a | --all)
    _unmount_all=true
    shift
    ;;
  -*)
    printf "error: invalid option '%s'\n" "$1" >&2
    exit 1
    ;;
  esac
done

if [[ "${_unmount_all}" == "true" ]]; then
  ls -1 ~/mounts/ | while read dir; do
    [[ $(mount | grep "mounts/$dir") ]] && umount ~/mounts/$dir
    [[ $(ls ~/mounts/$dir) ]] || rm -rf ~/mounts/$dir
  done
else
  [[ $(mount | grep "mounts/$1") ]] && umount ~/mounts/$1
  [[ $(ls ~/mounts/$1) ]] || rm -rf ~/mounts/$1
fi
