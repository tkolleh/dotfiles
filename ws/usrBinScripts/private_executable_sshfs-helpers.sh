#! /usr/bin/env bash
#
# =============================================================================
# Executed by bash for non-login shells.
#
# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# Public: Remote mount with sshfs
# 
# Creates folder on local system and mounts the specififed remote filesystem to the folder. Inspired by Brett Terpstra's [source code](https://github.com/ttscoff/dotfiles/blob/115e89fbac2391058364981ac83da85af79053b7/.bash_profile)
#
# [HOST:DEST] - Hostname and destination directory (HOST:DEST). Host is taken from set of hosts defined in ssh config. Destination directory is that of the remote host. 
#
# Examples
#
#   rmount ml:/home/ubuntu/fma-ws
#   # => 'mounted ~/mounts/fma-ws'
#
# Returns the exit code of the sshfs command or an exit code of 1.
rmount() {
  local host folder mname
  host="${1%%:*}:"
  [[ ${1%:} == ${host%%:*} ]] && folder='' || folder=${1##*:}
  if [[ $2 ]]; then
    mname=$2
  else
    mname=${folder##*/}
    [[ "$mname" == "" ]] && mname=${host%%:*}
  fi
  if [[ $(grep -i "host ${host%%:*}" ~/.ssh/config) != '' ]]; then
    mkdir -p ~/mounts/$mname > /dev/null
    sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=$mname,noappledouble && echo "mounted ~/mounts/$mname"
  else
    echo "No entry found for ${host%%:*}"
    return 1
  fi
}

# Public: Unmount remote directory(s) mounted with sshfs
#
# Unmounts remote directory(s) mounted with rmount and deletes their local
# folder. Inspired by Brett Terpstra's [source code](https://github.com/ttscoff/dotfiles/blob/115e89fbac2391058364981ac83da85af79053b7/.bash_profile).
#
# a      - Option to remove all mounted directories at ~/mounts
# [DEST] - Mounted directory to be unmounted
# 
# Examples
#
#   rumount fma-ws
#   # => ''
#
# Returns the exti code of the rm command or 0 otherwise.
rumount() {
  if [[ $1 == "-a" ]]; then
    ls -1 ~/mounts/|while read dir
    do
      [[ $(mount|grep "mounts/$dir") ]] && umount ~/mounts/$dir
      [[ $(ls ~/mounts/$dir) ]] || rm -rf ~/mounts/$dir
    done
  else
    [[ $(mount|grep "mounts/$1") ]] && umount ~/mounts/$1
    [[ $(ls ~/mounts/$1) ]] || rm -rf ~/mounts/$1
  fi
}
