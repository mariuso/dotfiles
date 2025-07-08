#!/bin/bash

# Phase 6: Post-Installation
# Final setup, authentication, and cleanup

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    info "Starting Phase 6: Post-Installation"
    
    # Setup authentication tools
    setup_authentication
    
    # Verify installation
    verify_installation
    
    # Display completion message
    display_completion_message
    
    success "Phase 6 completed: Installation finished!"
}

setup_authentication() {
    info "Setting up authentication tools..."
    
    # GitHub CLI authentication
    setup_github_auth
    
    # 1Password CLI authentication
    setup_1password_auth
}

setup_github_auth() {
    if ! command_exists gh; then
        warning "GitHub CLI not found - skipping authentication setup"
        return 0
    fi
    
    info "GitHub CLI is available"
    
    # Check if already authenticated
    if gh auth status >/dev/null 2>&1; then
        success "GitHub CLI already authenticated"
        return 0
    fi
    
    info "GitHub CLI authentication required"
    info "Please run 'gh auth login' manually after installation completes"
}

setup_1password_auth() {
    if ! command_exists op; then
        warning "1Password CLI not found - skipping authentication setup"
        return 0
    fi
    
    info "1Password CLI is available"
    info "Please run 'op signin' manually after installation completes"
    
    # Setup 1Password plugins if available
    if [[ -f "$HOME/.config/op/plugins.sh" ]]; then
        info "1Password plugins configuration found"
    else
        info "1Password plugins not yet configured"
        info "Run 'op plugin init vultr-cli' after signing in to 1Password"
    fi
}

verify_installation() {
    info "Verifying installation..."
    
    local checks_passed=0
    local checks_total=0
    
    # Check essential tools
    local tools=(
        "brew:Homebrew"
        "git:Git"
        "zsh:Zsh shell"
        "starship:Starship prompt"
        "gh:GitHub CLI"
    )
    
    for tool_info in "${tools[@]}"; do
        local tool="${tool_info%%:*}"
        local name="${tool_info##*:}"
        
        ((checks_total++))
        
        if command_exists "$tool"; then
            success "✓ $name is installed"
            ((checks_passed++))
        else
            error "✗ $name is not installed or not in PATH"
        fi
    done
    
    # Check configuration files
    local configs=(
        "$HOME/.zshrc:Zsh configuration"
        "$HOME/.gitconfig:Git configuration"
        "$HOME/.config/starship.toml:Starship configuration"
        "$HOME/.config/ghostty/config:Ghostty configuration"
    )
    
    for config_info in "${configs[@]}"; do
        local config="${config_info%%:*}"
        local name="${config_info##*:}"
        
        ((checks_total++))
        
        if [[ -f "$config" || -L "$config" ]]; then
            success "✓ $name is linked"
            ((checks_passed++))
        else
            error "✗ $name is missing"
        fi
    done
    
    # Summary
    info "Verification complete: $checks_passed/$checks_total checks passed"
    
    if [[ $checks_passed -eq $checks_total ]]; then
        success "All verification checks passed!"
    else
        warning "Some checks failed - review the output above"
    fi
}

display_completion_message() {
    echo ""
    echo "========================================"
    echo "🎉 Dotfiles Installation Complete! 🎉"
    echo "========================================"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Authenticate with GitHub: gh auth login"
    echo "3. Sign in to 1Password: op signin"
    echo "4. Configure any remaining application settings"
    echo ""
    echo "Installation log: $LOG_FILE"
    echo ""
    echo "Enjoy your new development environment! 🚀"
    echo ""
}

# Run main function
main "$@"