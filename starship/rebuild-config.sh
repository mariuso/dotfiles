#!/bin/bash
# Rebuild starship configuration with latest GCloud aliases
# Run after changing starship.toml or starship_gcloud_aliases.toml

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Import utilities
source "$DOTFILES_DIR/install/utils.sh"

main() {
    info "🔄 Rebuilding starship configuration..."

    "$SCRIPT_DIR/process-gcloud-aliases.sh"

    success "🎉 Starship configuration rebuilt!"
    info "Starship reloads the config automatically."
}

main "$@"
