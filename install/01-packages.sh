#!/bin/bash

# Phase 1: Package Installation
# Install Homebrew formulas and casks using Brewfile

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 1: Package Installation"
    
    # Check prerequisites
    check_prerequisites
    
    # Install packages from Brewfile
    install_packages
    
    # Clean up
    cleanup_packages
    
    success "Phase 1 completed: All packages installed"
}

check_prerequisites() {
    info "Checking prerequisites..."
    
    if ! has_homebrew; then
        fatal "Homebrew not found. Please run 00-prerequisites.sh first"
    fi
    
    local brewfile="$SCRIPT_DIR/../Brewfile"
    if [[ ! -f "$brewfile" ]]; then
        fatal "Brewfile not found at: $brewfile"
    fi
    
    success "Prerequisites check passed"
}

install_packages() {
    local brewfile="$SCRIPT_DIR/../Brewfile"
    
    info "Installing packages from Brewfile..."
    info "This may take a while depending on your internet connection"
    
    # Update Homebrew first
    info "Updating Homebrew..."
    run_cmd "brew update"
    
    # Install from Brewfile
    info "Installing packages..."
    if brew bundle --file="$brewfile" --verbose >> "$LOG_FILE" 2>&1; then
        success "All packages installed successfully"
    else
        warning "Some packages may have failed to install"
        info "Check the log file for details: $LOG_FILE"
    fi
    
    # Upgrade existing packages
    info "Upgrading existing packages..."
    run_cmd "brew upgrade"
}

cleanup_packages() {
    info "Cleaning up Homebrew..."
    
    # Clean up caches and old versions
    run_cmd "brew cleanup"
    
    # Run doctor to check for issues
    info "Running brew doctor..."
    if brew doctor >> "$LOG_FILE" 2>&1; then
        success "Homebrew health check passed"
    else
        warning "Homebrew doctor found some issues - check log for details"
    fi
}

# Run main function
main "$@"