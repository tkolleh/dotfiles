# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/tkolleh/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/tkolleh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/tkolleh/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/tkolleh/.fzf/shell/key-bindings.bash"
