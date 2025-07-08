#!/bin/bash

# Phase 3: Configuration Symlinks
# Create symlinks for all configuration files

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 3: Configuration Symlinks"
    
    # Setup shell configurations
    setup_shell_configs
    
    # Setup application configurations
    setup_app_configs
    
    # Copy themes
    copy_themes
    
    success "Phase 3 completed: All configurations linked"
}

setup_shell_configs() {
    info "Setting up shell configuration symlinks..."
    
    local dotfiles_dir="$SCRIPT_DIR/.."
    
    # Zsh configuration
    create_symlink "$dotfiles_dir/shell/.zshrc" "$HOME/.zshrc"
    
    # Git configuration
    create_symlink "$dotfiles_dir/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$dotfiles_dir/git/.gitignore" "$HOME/.gitignore"
    
    # SSH configuration (if config exists, not just template)
    if [[ -f "$dotfiles_dir/ssh/config" ]]; then
        ensure_dir "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        create_symlink "$dotfiles_dir/ssh/config" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
    else
        info "SSH config template available at: $dotfiles_dir/ssh/config.template"
        info "Use secure-configs/setup-machine.sh for secure config sync across machines"
    fi
    
    success "Shell configurations linked"
}

setup_app_configs() {
    info "Setting up application configuration symlinks..."
    
    local dotfiles_dir="$SCRIPT_DIR/.."
    
    # Starship configuration
    ensure_dir "$HOME/.config"
    create_symlink "$dotfiles_dir/starship/starship.toml" "$HOME/.config/starship.toml"
    
    # Ghostty configuration
    ensure_dir "$HOME/.config/ghostty"
    create_symlink "$dotfiles_dir/ghostty/config" "$HOME/.config/ghostty/config"
    
    success "Application configurations linked"
}

copy_themes() {
    info "Copying theme files..."
    
    local dotfiles_dir="$SCRIPT_DIR/.."
    local themes_src="$dotfiles_dir/themes"
    local themes_dest="$HOME/.themes"
    
    if [[ -d "$themes_src" ]]; then
        info "Syncing themes from $themes_src to $themes_dest"
        rsync -avh --no-perms "$themes_src/" "$themes_dest/" || {
            error "Failed to sync themes"
            return 1
        }
        success "Themes copied"
    else
        warning "Themes directory not found: $themes_src"
    fi
}

# Run main function
main "$@"