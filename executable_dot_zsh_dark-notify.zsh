#!/bin/zsh
# -*-mode:zsh-*- vim:ft=zsh
#
# ~/.zsh_dark-notify.zsh
# ====================================
# Changes when toggleing between dark / light mode
# Light mode is the default. Check if apple settings are for darkmode
#
#
# set -o errexit
# set -o pipefail
# set -o xtrace

function is_dark_mode() {
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
  if is_dark_mode; then
    # Set zsh auto suggest colors
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=237"
  else
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=248"
  fi
}

function set_prompt_mode() {
  # Change Starship prompt configuration based on Apple appearance
  # setting (light / dark mode) and the active iTerm2 profile
  if is_dark_mode && [[ $ITERM_PROFILE == "Github" ]]; then
      starship config palette dark
  else
      starship config palette light
  fi
  set_zsh_auto_suggest_colors
}

function set_bat_theme() {
  if is_dark_mode && (( ${+commands[bat]} )) && (( ${+commands[delta]} )); then
    export BAT_THEME="Dracula"
    export BATDIFF_USE_DELTA=true
  else
    export BAT_THEME="GitHub"
  fi
}

function set_terminal_to_dark_mode() {
  set_prompt_mode
  set_bat_theme
}

set_terminal_to_dark_mode
