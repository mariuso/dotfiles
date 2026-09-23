#!/bin/bash
# One-liner installer for dotfiles
# Usage: curl -fsSL https://raw.githubusercontent.com/mariuso/dotfiles/main/install-remote.sh | bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
# Clone over HTTPS (the repo is public, so no SSH key is needed yet), then
# switch the remote to SSH for pushing via the 1Password SSH agent
REPO_URL="https://github.com/mariuso/dotfiles.git"
PUSH_URL="git@github.com:mariuso/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
TEMP_DIR="/tmp/dotfiles-install-$$"

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This installer is designed for macOS only"
        exit 1
    fi
    
    info "✅ macOS detected"
}

install_xcode_tools() {
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode Command Line Tools..."
        xcode-select --install
        
        # Wait for installation to complete
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        success "✅ Xcode Command Line Tools installed"
    else
        info "✅ Xcode Command Line Tools already installed"
    fi
}

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        success "✅ Homebrew installed"
    else
        info "✅ Homebrew already installed"
    fi
}

clone_dotfiles() {
    info "Cloning dotfiles repository..."
    
    # Remove existing directory if it exists
    if [[ -d "$DOTFILES_DIR" ]]; then
        warning "Existing dotfiles directory found. Backing up to ${DOTFILES_DIR}.backup"
        mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
    
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    git remote set-url origin "$PUSH_URL"
    
    success "✅ Dotfiles cloned to $DOTFILES_DIR"
}

run_installation() {
    info "Running dotfiles installation..."
    cd "$DOTFILES_DIR"
    
    # Make the install script executable
    chmod +x install.sh
    
    # Run the main installation
    ./install.sh
    
    success "✅ Dotfiles installation completed"
}

setup_secure_configs() {
    info "Setting up secure configuration sync..."
    cd "$DOTFILES_DIR"
    
    # Check if 1Password CLI is available
    if command -v op &>/dev/null; then
        info "1Password CLI found. Setting up secure config sync..."
        
        # Try to check if user is signed in
        if op account list &>/dev/null; then
            info "Already signed in to 1Password. Running secure config setup..."
            ./secure-configs/setup-machine.sh
        else
            warning "1Password CLI found but not signed in."
            echo ""
            echo "To complete setup with secure config sync:"
            echo "1. Sign in to 1Password: op signin"
            echo "2. Run secure config setup: ./secure-configs/setup-machine.sh"
        fi
    else
        warning "1Password CLI not found in PATH yet."
        echo ""
        echo "After the shell restart, you can run:"
        echo "  op signin"
        echo "  setup-machine"
    fi
}

show_completion_message() {
    echo ""
    echo "🎉 Installation Complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: exec zsh"
    echo "2. If you use 1Password for config sync:"
    echo "   • Sign in: op signin"
    echo "   • Set up configs: setup-machine"
    echo ""
    echo "Useful commands:"
    echo "  sync-configs backup   - Backup configs to 1Password"
    echo "  sync-configs restore  - Restore configs from 1Password"
    echo "  sync-configs list     - List available configs"
    echo ""
    echo "Enjoy your new setup! 🚀"
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

main() {
    # Set up cleanup trap
    trap cleanup EXIT
    
    echo "🚀 Starting dotfiles installation..."
    echo ""
    
    check_os
    install_xcode_tools
    install_homebrew
    clone_dotfiles
    run_installation
    setup_secure_configs
    show_completion_message
    
    success "🎊 All done!"
}

# Run main function
main "$@"