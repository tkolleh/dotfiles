#!/bin/zsh
# -*-mode:zsh-*- vim:ft=zsh
#
# ~/.zsh_dark-notify.zsh
# ====================================
# Change terminal appearance based on on MacOS appearance setting for
# dark or light mode. Light mode is the default.
#
# set -o errexit
# set -o pipefail
# set -o xtrace

function is_dark_mode() {
  # Return 0 if MacOs is in dark mode. Return non zero otherwise.
  if [[ "$(uname -s)" == "Darwin" ]]; then
    local interface_mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    if [[ $interface_mode == "Dark" ]]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function set_zsh_auto_suggest_colors() {
  # Change [zsh auto suggestion](https://github.com/zsh-users/zsh-autosuggestions) plugin terminal color
  # based on Apple appearance light or dark mode setting
  if [[ "$1" == "0" ]]; then
    # Set zsh auto suggest colors
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=237"
  else
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=248"
  fi
}

function set_terminal_to_dark_mode() {
  # Change terminal appearance if the MacOS appearance differs from the terminal
  # appearance. Where _TERM_APPEARANCE stores the previous os_appearance value i.e.
  # if previous appearance differs from the current appearance then update.
  is_dark_mode
  local is_dark_exit_code=$?
  if ! [[ -v _TERM_APPEARANCE ]]; then
    export _TERM_APPEARANCE=9
  fi
  if [[ $is_dark_exit_code -ne $_TERM_APPEARANCE ]]; then
    export _TERM_APPEARANCE_IS_DARK=$is_dark_exit_code
    set_zsh_auto_suggest_colors $is_dark_exit_code
  fi
}

set_terminal_to_dark_mode
