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
  if (( ${+commands[dark-notify]} )); then
    if dark-notify -e | grep -q "dark"; then
      return 0
    else
      return 1
    fi
  elif [[ "$(uname -s)" == "Darwin" ]]; then
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
  if is_dark_mode; then
    # Set zsh auto suggest colors
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=237"
  else
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=248"
  fi
}

function set_prompt_mode() {
  # Change the PROMPT based via [Starship](https://github.com/starship/starship)
  # based on Apple appearance light or dark mode setting
  if is_dark_mode && [[ $ITERM_PROFILE == "Github" ]]; then
      starship config palette dark
  else
      starship config palette light
  fi
  set_zsh_auto_suggest_colors
}

function set_bat_theme() {
  # Change the [bat](https://github.com/sharkdp/bat) theme
  # based on Apple appearance light or dark mode setting
  if is_dark_mode && (( ${+commands[bat]} )) && (( ${+commands[delta]} )); then
    export BAT_THEME="Dracula"
    export BATDIFF_USE_DELTA=true
  else
    export BAT_THEME="GitHub"
  fi
}

function set_terminal_to_dark_mode() {
  # Change terminal appearance if the MacOS appearance differs from the terminal
  # appearance. Where _TERM_APPEARANCE stores the previous os_appearance value i.e.
  # if previous appearance differs from the current appearance then update.
  is_dark_mode
  local os_appearance_exit_code=$?
  # echo "MacOS appearance is [${os_appearance_exit_code}] (dark=0, light=1)"
  # echo "Terminal appearnace is [${_TERM_APPEARANCE}] (dark=0, light=1)"
  if [[ $os_appearance_exit_code -ne $_TERM_APPEARANCE ]]; then
    set_prompt_mode
    set_bat_theme
    export _TERM_APPEARANCE=$os_appearance_exit_code
  fi
}

set_terminal_to_dark_mode
