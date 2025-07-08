#!/bin/bash

# Phase 5: Development Environment
# Setup development tools, SDKs, and programming environments

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 5: Development Environment"
    
    # Setup programming languages
    setup_programming_languages
    
    # Setup Java environment
    setup_java_environment
    
    # Setup DNS development tools
    setup_dnsmasq
    
    success "Phase 5 completed: Development environment ready"
}

setup_programming_languages() {
    info "Setting up programming language environments..."
    
    # Check if asdf is available for language management
    if command_exists asdf; then
        setup_asdf_languages
    elif command_exists mise; then
        setup_mise_languages
    else
        warning "No version manager found (asdf/mise) - skipping language setup"
        return 0
    fi
}

setup_asdf_languages() {
    info "Setting up languages with asdf..."
    
    # Node.js
    setup_asdf_plugin "nodejs"
    
    # Python
    setup_asdf_plugin "python"
    
    # Bun
    setup_asdf_plugin "bun"
    
    # Install global npm packages
    install_global_npm_packages
}

setup_mise_languages() {
    info "Setting up languages with mise..."
    
    # Node.js
    setup_mise_plugin "node"
    
    # Python  
    setup_mise_plugin "python"
    
    # Bun
    setup_mise_plugin "bun"
    
    # Install global npm packages
    install_global_npm_packages
}

setup_asdf_plugin() {
    local plugin="$1"
    
    info "Setting up asdf plugin: $plugin"
    
    # Add plugin if not already added
    if ! asdf plugin list | grep -q "^$plugin$"; then
        info "Adding asdf plugin: $plugin"
        run_cmd "asdf plugin add $plugin"
    fi
    
    # Install latest version
    info "Installing latest $plugin..."
    run_cmd "asdf install $plugin latest"
    run_cmd "asdf global $plugin latest"
    
    success "$plugin setup completed"
}

setup_mise_plugin() {
    local plugin="$1"
    
    info "Setting up mise plugin: $plugin"
    
    # Install latest version
    info "Installing latest $plugin with mise..."
    run_cmd "mise install $plugin@latest"
    run_cmd "mise global $plugin@latest"
    
    success "$plugin setup completed"
}

install_global_npm_packages() {
    info "Installing global npm packages..."
    
    local packages=(
        "yarn"
        "turbo"
    )
    
    for package in "${packages[@]}"; do
        info "Installing global npm package: $package"
        run_cmd "npm install -g $package"
    done
    
    success "Global npm packages installed"
}

setup_java_environment() {
    info "Setting up Java environment..."
    
    # Check if OpenJDK is installed
    if ! command_exists java; then
        warning "Java not found - make sure OpenJDK is installed via Homebrew"
        return 1
    fi
    
    # Setup JDK symlink for system recognition
    local jdk_path
    if [[ -d "/opt/homebrew/opt/openjdk@21" ]]; then
        jdk_path="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk"
    elif [[ -d "/usr/local/opt/openjdk@21" ]]; then
        jdk_path="/usr/local/opt/openjdk@21/libexec/openjdk.jdk"
    else
        warning "OpenJDK@21 not found in expected locations"
        return 1
    fi
    
    info "Creating system JDK symlink..."
    if sudo ln -sfn "$jdk_path" "/Library/Java/JavaVirtualMachines/openjdk-21.jdk" 2>> "$LOG_FILE"; then
        success "Java environment configured"
    else
        error "Failed to create JDK symlink - check permissions"
    fi
}

setup_dnsmasq() {
    info "Setting up dnsmasq for local development..."
    
    local dnsmasq_script="$SCRIPT_DIR/dnsmasq.sh"
    
    if [[ -f "$dnsmasq_script" ]]; then
        info "Running dnsmasq setup script..."
        bash "$dnsmasq_script" >> "$LOG_FILE" 2>&1 || {
            warning "dnsmasq setup failed - check log for details"
        }
        success "dnsmasq configured"
    else
        warning "dnsmasq setup script not found: $dnsmasq_script"
    fi
}

# Run main function
main "$@"