#!/bin/bash

# Phase 4: macOS Configuration
# Apply macOS system defaults and preferences

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 4: macOS Configuration"
    
    # Ensure we're on macOS
    if ! is_macos; then
        warning "Skipping macOS configuration - not running on macOS"
        return 0
    fi
    
    # Ask for confirmation
    if ! confirm "Apply macOS system defaults? This will modify system preferences"; then
        info "Skipping macOS configuration"
        return 0
    fi
    
    # Apply macOS defaults
    apply_macos_defaults
    
    # Setup TouchID for sudo
    setup_sudo_touchid
    
    success "Phase 4 completed: macOS configured"
}

apply_macos_defaults() {
    info "Applying macOS system defaults..."
    
    local macos_script="$SCRIPT_DIR/../macos/macos-defaults.sh"
    
    if [[ ! -f "$macos_script" ]]; then
        error "macOS defaults script not found: $macos_script"
        return 1
    fi
    
    # Make script executable
    chmod +x "$macos_script"
    
    # Run the macOS defaults script
    info "Running macOS defaults script..."
    if bash "$macos_script" >> "$LOG_FILE" 2>&1; then
        success "macOS defaults applied"
    else
        error "Failed to apply macOS defaults - check log for details"
        return 1
    fi
}

setup_sudo_touchid() {
    info "Setting up TouchID for sudo..."
    
    local touchid_script="$SCRIPT_DIR/../macos/enable-sudo-touchid.sh"
    
    if [[ ! -f "$touchid_script" ]]; then
        error "TouchID script not found: $touchid_script"
        return 1
    fi
    
    # Make script executable
    chmod +x "$touchid_script"
    
    # Run the TouchID setup script
    info "Enabling TouchID for sudo (requires admin password)..."
    if bash "$touchid_script" >> "$LOG_FILE" 2>&1; then
        success "TouchID for sudo enabled"
    else
        warning "Failed to enable TouchID for sudo - check log for details"
    fi
}

# Run main function
main "$@"