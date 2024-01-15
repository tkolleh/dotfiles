#!/bin/zsh
# -*-mode:zsh-*- vim:ft=zsh
#
# ~/.config/chezmoi/idea_merge_tool.sh
# ====================================
#

local dest="${1}"
local remote="${3}"
local base="${2}"

idea merge "${dest}" "${base}" "${remote}"
