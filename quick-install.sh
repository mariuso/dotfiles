#!/bin/bash
# Quick installer for new machines
# Run this after cloning the repository

set -euo pipefail

echo "🚀 Quick Setup for New Mac"
echo "=========================="
echo ""

# Check if we're in the dotfiles directory
if [[ ! -f "install.sh" ]]; then
    echo "❌ Please run this from the dotfiles directory"
    echo "First clone the repo: git clone https://github.com/mariuso/dotfiles.git ~/.dotfiles"
    exit 1
fi

# Install Xcode tools if needed
if ! xcode-select -p &>/dev/null; then
    echo "📱 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Xcode installation and run this script again"
    exit 0
fi

# Install Homebrew if needed
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH for Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo "✅ Prerequisites ready"
echo ""

# Run the main installation
echo "🔧 Running full dotfiles installation..."
./install.sh

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal: exec zsh"
echo "2. Sign in to 1Password: op signin"
echo "3. Set up configs: setup-machine"
echo ""
echo "Enjoy your new setup! 🚀"