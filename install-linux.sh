#!/usr/bin/env bash
# Link the portable parts of these dotfiles on a Linux host (e.g. a dev VM).
# The macOS installer (install.sh) is not used there: it relies on Homebrew,
# macOS defaults and GUI apps. Programs (zsh, starship, nvim, tmux) are
# installed by the host's provisioning;
# this only links configuration. Safe to re-run; replaced files are backed up.
#
#   git clone https://github.com/mariuso/dotfiles.git ~/.dotfiles
#   ~/.dotfiles/install-linux.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() { # link SOURCE TARGET
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        echo "ok      $dst"
        return
    fi
    if [[ -e "$dst" || -L "$dst" ]]; then
        mv "$dst" "$dst.backup.$(date +%Y%m%d-%H%M%S)"
        echo "backup  $dst"
    fi
    ln -s "$src" "$dst"
    echo "linked  $dst -> $src"
}

[[ "$(uname -s)" == Linux ]] || { echo "Linux only; use install.sh on macOS" >&2; exit 1; }

link "$DOTFILES_DIR/shell/.zshrc.linux" "$HOME/.zshrc"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore"
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != *zsh ]]; then
    echo "note    login shell is not zsh; run: sudo chsh -s \"\$(command -v zsh)\" \"\$USER\""
fi
echo "done. Start a new shell (exec zsh), then open nvim once to install plugins."
