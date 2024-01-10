#!/bin/zsh
# -*-mode:zsh-*- vim:ft=zsh
#
# ~/.config/chezmoi/idea_merge_tool.sh
# ====================================
#

local dest="${1}"
local chezmoi="${2}"
local base="${3}"

idea merge "${dest}" "${chezmoi}" "${base}" "${chezmoi}"
