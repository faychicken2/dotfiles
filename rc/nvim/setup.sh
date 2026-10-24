#!/usr/bin/env bash
# Deploy the dotfiles configuration and bootstrap Neovim plugins.
set -Eeuo pipefail
umask 077

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
REPO=$(cd -- "$SCRIPT_DIR/../.." && pwd -P)
CONFIG="$HOME/.config/nvim"

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

[[ ${HOME:-} == /* && -d $HOME && $HOME != / ]] || fail "HOME must be an existing absolute directory other than /"
command -v nvim >/dev/null 2>&1 || fail "Neovim is not installed. Install it with your distribution's package manager first."
command -v git >/dev/null 2>&1 || fail "Git is required to download Neovim plugins."
[[ -x "$REPO/install.sh" ]] || fail "Run this script from an existing dotfiles repository checkout."

echo "Deploying the repository configuration..."
"$REPO/install.sh"

echo "Starting Neovim once to install declared plugins..."
if ! nvim --headless -u "$CONFIG/init.lua" -c 'qa' 2>&1; then
    fail "Neovim plugin bootstrap failed. Start Neovim normally to inspect the error."
fi

echo "Neovim setup complete."
echo "Language servers and Tree-sitter parsers can be installed from inside Neovim with Mason and their normal commands."
