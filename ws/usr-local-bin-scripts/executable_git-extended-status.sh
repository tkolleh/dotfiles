#! /usr/bin/env bash
#
# =============================================================================
#
# symlinked to /usr/local/bin/<filename>
#

#/ Usage: gtsp [options]
#/
#/    -h, --help      show help text
#/
#/ Prints the list of project branches sorted by committerdate with the git
#/ status using colored formatting
#/
#/ Returns the exit of the last command executed or the bat pager

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
trap "rm -f \"$tmpfile\"" EXIT # Automatically delete temporary file on exit
git -c 'color.ui=always' --no-pager branch --color -vva --sort=-committerdate >"$tmpfile"
git -c 'color.ui=always' -c 'color.status=always' --no-pager status -b --ignored >>"$tmpfile"

linecount=$(wc -l $tmpfile | awk '{print $1}')
bat --highlight-line="$linecount" --color=always --paging=always "$tmpfile"
