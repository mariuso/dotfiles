#!/bin/bash

# Phase 0: Prerequisites
# Install Xcode Command Line Tools and Homebrew

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 0: Prerequisites"
    
    # Ensure we're on macOS
    if ! is_macos; then
        fatal "This script is designed for macOS only"
    fi
    
    # Check not running as sudo
    check_not_sudo
    
    # Initialize logging
    init_logging
    
    # Install Xcode Command Line Tools
    install_xcode_tools
    
    # Install Homebrew
    install_homebrew
    
    success "Phase 0 completed: Prerequisites installed"
}

install_xcode_tools() {
    info "Checking Xcode Command Line Tools..."
    
    if xcode-select -p >/dev/null 2>&1; then
        success "Xcode Command Line Tools already installed"
        return 0
    fi
    
    info "Installing Xcode Command Line Tools..."
    info "This may take a while and will open a dialog"
    
    # Trigger installation
    xcode-select --install || {
        error "Failed to start Xcode Command Line Tools installation"
        info "Please install manually and re-run this script"
        return 1
    }
    
    # Wait for installation to complete
    info "Waiting for Xcode Command Line Tools installation to complete..."
    while ! xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
    
    success "Xcode Command Line Tools installed"
}

install_homebrew() {
    info "Checking Homebrew installation..."
    
    if has_homebrew; then
        success "Homebrew already installed"
        info "Updating Homebrew..."
        run_cmd "brew update"
        return 0
    fi
    
    info "Installing Homebrew..."
    info "This will require your password"
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        fatal "Failed to install Homebrew"
    }
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Add to shell profile
        if [[ ! -f "$HOME/.zprofile" ]] || ! grep -q "homebrew" "$HOME/.zprofile"; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        fi
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        if [[ ! -f "$HOME/.zprofile" ]] || ! grep -q "homebrew" "$HOME/.zprofile"; then
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        fi
    else
        fatal "Homebrew installation completed but brew command not found"
    fi
    
    success "Homebrew installed and configured"
}

# Run main function
main "$@"