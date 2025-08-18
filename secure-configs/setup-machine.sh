#!/bin/bash
# New Machine Setup Script
# Automates the setup of a new machine with secure config sync

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
SYNC_SCRIPT="$SCRIPT_DIR/sync-configs.sh"

# Import utilities
source "$DOTFILES_DIR/install/utils.sh"

setup_1password_integration() {
    info "🔐 Setting up 1Password integration..."
    
    if ! command_exists op; then
        info "Installing 1Password CLI..."
        if command_exists brew; then
            brew install 1password-cli
        else
            error "Homebrew not found. Please install 1Password CLI manually."
            exit 1
        fi
    fi
    
    if ! op account list &>/dev/null; then
        info "Please sign in to 1Password:"
        op signin
    fi
    
    success "✅ 1Password integration ready"
}

setup_ssh() {
    info "🔑 Setting up SSH configuration..."
    
    # Ensure .ssh directory exists with proper permissions
    ensure_dir "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Download SSH config from 1Password if available
    if "$SYNC_SCRIPT" list | grep -q "SSH Config"; then
        info "Found SSH config in 1Password, downloading..."
        echo "y" | "$SYNC_SCRIPT" restore
    else
        info "No SSH config found in 1Password, using template..."
        if [[ -f "$DOTFILES_DIR/ssh/config.template" ]]; then
            cp "$DOTFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
            chmod 600 "$HOME/.ssh/config"
            info "SSH config template copied. Customize it and run '$SYNC_SCRIPT backup' to sync."
        fi
    fi
    
    success "✅ SSH setup complete"
}

setup_cloud_configs() {
    info "☁️  Setting up cloud provider configurations..."
    
    # Create config directories
    ensure_dir "$HOME/.aws"
    ensure_dir "$HOME/.config/gcloud"
    ensure_dir "$HOME/.kube"
    ensure_dir "$HOME/.docker"
    ensure_dir "$HOME/.config/op"
    
    # Try to restore configs from 1Password
    info "Attempting to restore cloud configs from 1Password..."
    "$SYNC_SCRIPT" restore || warning "Some configs may not be available in 1Password yet"
    
    # Process starship gcloud aliases after config restore
    if [[ -x "$DOTFILES_DIR/starship/process-gcloud-aliases.sh" ]]; then
        info "Processing GCloud aliases for starship prompt..."
        "$DOTFILES_DIR/starship/process-gcloud-aliases.sh"
    fi
    
    success "✅ Cloud configs setup complete"
}

setup_development_tools() {
    info "🛠️  Setting up development tool configurations..."
    
    # Node.js/NPM
    if command_exists npm; then
        info "Configuring NPM..."
        # NPM config will be restored by sync script if available
    fi
    
    # Terraform
    if command_exists terraform; then
        info "Terraform found, config will be synced if available"
    fi
    
    success "✅ Development tools configured"
}

verify_setup() {
    info "🔍 Verifying setup..."
    
    local issues=0
    
    # Check SSH
    if [[ -f "$HOME/.ssh/config" ]]; then
        success "✅ SSH config present"
    else
        warning "❌ SSH config missing"
        ((issues++))
    fi
    
    # Check 1Password CLI
    if op account list &>/dev/null; then
        success "✅ 1Password CLI authenticated"
    else
        warning "❌ 1Password CLI not authenticated"
        ((issues++))
    fi
    
    # Check critical directories
    local dirs=("$HOME/.ssh" "$HOME/.aws" "$HOME/.config/gcloud")
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            success "✅ Directory exists: $dir"
        else
            warning "❌ Directory missing: $dir"
            ((issues++))
        fi
    done
    
    if ((issues == 0)); then
        success "🎉 Setup verification complete - all good!"
    else
        warning "⚠️  Setup verification found $issues issues"
        info "Run the setup again or manually address the issues above"
    fi
}

show_next_steps() {
    cat << EOF

🎉 Machine setup complete!

Next steps:
1. Customize your SSH config if needed: ~/.ssh/config
2. Set up cloud provider authentication:
   • AWS: aws configure
   • Google Cloud: gcloud auth login
   • Kubernetes: Add your cluster configs

3. Backup any new configs: $SYNC_SCRIPT backup

4. On future machines, just run: $0

Useful commands:
• $SYNC_SCRIPT list     - Show configs in 1Password
• $SYNC_SCRIPT backup   - Backup current configs
• $SYNC_SCRIPT restore  - Restore configs from 1Password

EOF
}

main() {
    info "🚀 Starting new machine setup..."
    
    setup_1password_integration
    setup_ssh
    setup_cloud_configs
    setup_development_tools
    verify_setup
    show_next_steps
    
    success "🎊 New machine setup complete!"
}

main "$@"