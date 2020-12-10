#!/bin/sh
# -*-mode:sh-*- vim:ft=shell-script

# ~/dotfiles.sh
# =============================================================================
# Idempotent manual setup script to install or update shell dependencies.

set -e

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

error() {
    printf -- "%sError: $*%s\n" >&2 "$RED" "$RESET"
}

setup_color() {
    # Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        # YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        # YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

import_repo() {
    repo=$1
    destination=$2
    if uname | grep -Eq '^(cygwin|mingw|msys)'; then
        uuid=$(powershell -NoProfile -Command "[guid]::NewGuid().ToString()")
    else
        uuid=$(uuidgen)
    fi
    TMPFILE=$(mktemp /tmp/dotfiles."${uuid}".tar.gz) || exit 1
    curl -s -L -o "$TMPFILE" "$repo" || exit 1
    chezmoi import --strip-components 1 --destination "$destination" "$TMPFILE" || exit 1
    rm -f "$TMPFILE"
}

setup_dependencies() {
    printf -- "\n%sSetting up dependencies:%s\n\n" "$BOLD" "$RESET"

    # Install Homebrew packages
    if command -v brew > /dev/null; then
        printf -- "%sInstalling/updating apps using Homebrew...%s\n" "$BLUE" "$RESET"
        brew bundle --global
    fi
}

setup_prompts() {
    printf -- "\n%sSetting up shell frameworks:%s\n\n" "$BOLD" "$RESET"

    # Install Oh My Zsh
    PACKAGE_NAME='Oh My Zsh'
    printf -- "%sInstalling/updating %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    CHEZMOIPATH=$(chezmoi source-path)
    rm -rf "$CHEZMOIPATH"/dot_oh-my-zsh/plugins
    import_repo 'https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz' "${HOME}/.oh-my-zsh" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

    # Install Zsh themes
    PACKAGE_NAME='Powerlevel9k'
    printf -- "%sInstalling/updating Zsh theme: %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    import_repo 'https://github.com/Powerlevel9k/powerlevel9k/archive/master.tar.gz' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel9k" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

}

setup_applications() {
    printf -- "\n%sSetting up CLI applications:%s\n\n" "$BOLD" "$RESET"

    # Install Tmux Plugin Manager
    PACKAGE_NAME='Tmux Plugin Manager'
    printf -- "%sInstalling/updating %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    CHEZMOIPATH=$(chezmoi source-path)
    mkdir -pv "$CHEZMOIPATH"/dot_tmux/plugins/tpm
    import_repo 'https://github.com/tmux-plugins/tpm/archive/master.tar.gz' "${HOME}/.tmux/plugins/tpm" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }
}

# shellcheck source=/dev/null
setup_devtools() {
    printf -- "\n%sSetting up development tools:%s\n\n" "$BOLD" "$RESET"

    command_exists git || {
        error "git is not installed"
        exit 1
    }

    command_exists nvm || {
        error "nvm is not installed"
        exit 1
    }

    # Install Node.js
    printf -- "%sInstalling/updating Node.js...%s\n" "$BLUE" "$RESET"
    nvm install node
}

finalize_dotfiles() {
    printf -- "\n%sFinalizing dotfiles:%s\n\n" "$BOLD" "$RESET"

    printf -- "%sUpdating dotfiles at destination...%s\n" "$BLUE" "$RESET"
    chezmoi apply
}

main() {
    printf -- "\n%sDotfiles setup script%s\n" "$BOLD" "$RESET"

    command_exists chezmoi || {
        error "chezmoi is not installed"
        exit 1
    }

    setup_dependencies
    setup_color
    setup_prompts
    setup_applications
    setup_devtools
    finalize_dotfiles

    printf -- "\n%sDone.%s\n\n" "$GREEN" "$RESET"

    # if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    #    [ -s "$HOME/.zshrc" ] && \. "$HOME/.zshrc"
    # elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
    #    [ -s "$HOME/.bashrc" ] && \. "$HOME/.bashrc"
    # fi
}

main "$@"

