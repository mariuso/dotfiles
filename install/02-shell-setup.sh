#!/bin/bash

# Phase 2: Shell Setup
# Install and configure zsh, oh-my-zsh, and shell enhancements

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 2: Shell Setup"
    
    # Create necessary directories
    setup_directories
    
    # Install oh-my-zsh
    install_oh_my_zsh
    
    # Setup version managers
    setup_version_managers
    
    success "Phase 2 completed: Shell setup finished"
}

setup_directories() {
    info "Creating shell configuration directories..."
    
    local dirs=(
        "$HOME/Developer"
        "$HOME/Developer/Work"
        "$HOME/Developer/Private"
        "$HOME/Developer/Infrastructure"
        "$HOME/Documents/Screenshots"
        "$HOME/Work"
        "$HOME/.config"
        "$HOME/.themes"
        "$HOME/.tmp-installers"
    )
    
    for dir in "${dirs[@]}"; do
        ensure_dir "$dir"
    done
    
    success "Directories created"
}

install_oh_my_zsh() {
    info "Setting up Oh My Zsh..."
    
    # Check if already installed
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        success "Oh My Zsh already installed"
        return 0
    fi
    
    # Download and install
    info "Installing Oh My Zsh..."
    local installer="$HOME/.tmp-installers/install-ohmyzsh.sh"
    
    if curl -fsSL -o "$installer" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"; then
        success "Downloaded Oh My Zsh installer"
    else
        fatal "Failed to download Oh My Zsh installer"
    fi
    
    # Run installer in unattended mode
    bash "$installer" --unattended || {
        fatal "Failed to install Oh My Zsh"
    }
    
    success "Oh My Zsh installed"
}

setup_version_managers() {
    info "Setting up version managers..."
    
    # Setup mise (if available)
    if command_exists mise; then
        setup_mise
    else
        warning "mise not found - skipping version manager setup"
    fi
}

setup_mise() {
    info "Configuring mise version manager..."
    
    # Add yarn plugin
    if mise plugin list | grep -q yarn; then
        info "Yarn plugin already installed"
    else
        info "Installing yarn plugin..."
        run_cmd "mise plugin install yarn"
    fi
    
    # Update plugins
    info "Updating mise plugins..."
    run_cmd "mise plugin update yarn"
    
    success "mise configured"
}

# Run main function
main "$@"