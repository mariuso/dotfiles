#!/bin/bash

# Dotfiles Installation Utilities
# Common functions for all installation scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging setup
LOG_FILE="$HOME/.dotfiles-install.log"
SCRIPT_START_TIME=$(date +%s)

# Initialize logging
init_logging() {
    echo "=== Dotfiles Installation Started: $(date) ===" > "$LOG_FILE"
    echo "User: $(whoami)" >> "$LOG_FILE"
    echo "System: $(uname -a)" >> "$LOG_FILE"
    echo "===========================================" >> "$LOG_FILE"
    echo ""
}

# Logging functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
    log "INFO: $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
    log "SUCCESS: $*"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
    log "WARNING: $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
    log "ERROR: $*"
}

fatal() {
    echo -e "${RED}[FATAL]${NC} $*"
    log "FATAL: $*"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Check if Homebrew is installed
has_homebrew() {
    command_exists brew
}

# Check if script is run with sudo (should not be)
check_not_sudo() {
    if [[ $EUID -eq 0 ]]; then
        fatal "This script should not be run as root/sudo"
    fi
}

# Ask for user confirmation
confirm() {
    local prompt="$1"
    local default="${2:-y}"
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -p "$prompt" -n 1 -r
    echo
    
    if [[ "$default" == "y" ]]; then
        [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
    else
        [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        info "Creating directory: $dir"
        mkdir -p "$dir" || fatal "Failed to create directory: $dir"
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if source exists
    if [[ ! -e "$source" ]]; then
        error "Source file does not exist: $source"
        return 1
    fi
    
    # Create target directory if needed
    local target_dir
    target_dir=$(dirname "$target")
    ensure_dir "$target_dir"
    
    # Backup existing file/symlink
    if [[ -e "$target" || -L "$target" ]]; then
        local backup
        backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warning "Backing up existing file: $target -> $backup"
        mv "$target" "$backup"
    fi
    
    # Create symlink
    info "Creating symlink: $target -> $source"
    ln -sf "$source" "$target" || {
        error "Failed to create symlink: $target -> $source"
        return 1
    }
    
    success "Symlink created: $target"
}

# Run command with error checking
run_cmd() {
    local cmd="$*"
    info "Running: $cmd"
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        success "Command completed: $cmd"
        return 0
    else
        error "Command failed: $cmd"
        return 1
    fi
}

# Install Homebrew package
brew_install() {
    local package="$1"
    
    if brew list "$package" >/dev/null 2>&1; then
        info "Already installed: $package"
        return 0
    fi
    
    info "Installing Homebrew package: $package"
    if brew install "$package" >> "$LOG_FILE" 2>&1; then
        success "Installed: $package"
        return 0
    else
        error "Failed to install: $package"
        return 1
    fi
}

# Install Homebrew cask
brew_cask_install() {
    local cask="$1"
    
    if brew list --cask "$cask" >/dev/null 2>&1; then
        info "Already installed: $cask"
        return 0
    fi
    
    info "Installing Homebrew cask: $cask"
    if brew install --cask "$cask" >> "$LOG_FILE" 2>&1; then
        success "Installed: $cask"
        return 0
    else
        error "Failed to install: $cask"
        return 1
    fi
}

# Cleanup function
cleanup() {
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - SCRIPT_START_TIME))
    
    echo ""
    echo "=== Installation completed in ${duration}s ===" >> "$LOG_FILE"
    success "Installation log saved to: $LOG_FILE"
}

# Setup cleanup trap
trap cleanup EXIT