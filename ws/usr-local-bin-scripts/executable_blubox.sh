#! /usr/bin/env bash
#
# =============================================================================
#
# symlinked to /usr/local/bin/<filename>
#

#/ Usage: bluebox [options]
#/
#/    -h, --help show help text
#/
#/ Establish an SSH connection with the unraid host defined in the ssh
#/ config file. If connection attempt failed due to an authentication
#/ error, authorize user by adding their public key to the remote users
#/ ~/.ssh/authorized_keys.
#/
#/ Returns the exit code of the ssh command
#/
# =============================================================================

# Print above comments as when help option is given
while test "$#" -ne 0; do
  case "$1" in
  -h | --h | --he | --hel | --help)
    grep '^#/' <"$0" | cut -c4-
    exit 0
    ;;
  -*)
    printf "error: invalid option '%s'\n" "$1" >&2
    exit 1
    ;;
  esac
done

tmpfile="$(mktemp)"
trap "rm -f \"$tmpfile\"" EXIT

LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/xterm/)

IDFILE=$(ssh -G unraid | awk '/^identityfile/ {print $2}')
USERNAME=$(ssh -G unraid | awk '/^user/ {print $2}')
NAME=$(ssh -G unraid | awk '/^hostname/ {print $2}')

ssh -q -o BatchMode=yes -o ConnectTimeout=5 -E "$tmpfile" $USERNAME@"$NAME" -f "exit"
RCODE=$?

grep -m 1 -o -E 'Permission denied' $tmpfile >/dev/null
RCODE_G=$?

if [ "$RCODE" -ne 255 ] && [ "$RCODE" -ne 0 ] || [ "$RCODE_G" -eq 0 ]; then
  # echo "RCODE was $RCODE and RCODE_G was $RCODE_G"
  ssh-copy-id -o PreferredAuthentications=password -i "$IDFILE.pub" $USERNAME@"$NAME"
  env TERM=$LOCAL_TERM ssh unraid
else
  env TERM=$LOCAL_TERM ssh unraid
fi
