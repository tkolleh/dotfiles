#! /usr/bin/env bash
#
# =============================================================================
#
# symlinked to /usr/local/bin/<filename>
#

#/ Usage: black_selection [options]
#/
#/    -h, --help show help text
#/
#/ Run black on partially selected text This code is based on shell script
#/ (https://gist.github.com/BasPH/5e665273d5e4cb8a8eefb6f9d43b0b6d)
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

set -ex

black=$1
input_file=$2
start_line=$3
end_line=$4

# Read selected lines and write to tmpfile
selection=$(sed -n "$start_line, $end_line p; $(($end_line+1)) q" < $input_file)
tmpfile=$(mktemp)
echo "$selection" > "$tmpfile"

# Apply Black formatting to tmpfile
$black $tmpfile

# Delete original lines from file
sed -i "" "$start_line,$end_line d" $input_file

# And insert newly formatted lines
sed -i "" "$(($start_line-1)) r $tmpfile" $input_file
