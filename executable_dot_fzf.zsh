#!/usr/bin/env zsh
# Setup fzf
# ---------
export FZF_PATH=${FZF_PATH:-"`brew --prefix fzf`"}
if [[ ! "$PATH" == *${FZF_PATH}/bin* ]]; then
  export PATH="$PATH:${FZF_PATH}/bin"
fi

# Auto-completion if this is an interactive shell
# ---------------
[[ $- == *i* ]] && source "${FZF_PATH}/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_PATH}/shell/key-bindings.zsh"

