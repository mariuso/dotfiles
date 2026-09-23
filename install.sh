#!/bin/bash

# Dotfiles Installation Script
# Modular installation system for macOS development environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"

# Available phases
PHASES=(
    "00-prerequisites:Prerequisites (Xcode tools, Homebrew)"
    "01-packages:Package Installation (Brewfile)"
    "02-shell-setup:Shell Setup (Zsh, Oh My Zsh)"
    "03-symlinks:Configuration Symlinks"
    "04-macos-config:macOS Configuration"
    "05-development:Development Environment"
    "06-post-install:Post-Installation Setup"
)

# Default configuration
DEFAULT_HOSTNAME="marius-macbook"
RUN_ALL_PHASES=true
SELECTED_PHASES=()

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install and configure dotfiles for macOS development environment.

OPTIONS:
    -h, --help              Show this help message
    -a, --all               Run all installation phases (default)
    -p, --phase PHASE       Run specific phase(s) only
    -l, --list              List available phases
    -n, --hostname NAME     Set hostname (default: $DEFAULT_HOSTNAME)
    --dry-run              Show what would be done without executing

PHASES:
EOF

    for phase_info in "${PHASES[@]}"; do
        local phase="${phase_info%%:*}"
        local desc="${phase_info##*:}"
        printf "    %-20s %s\n" "$phase" "$desc"
    done

    cat << EOF

EXAMPLES:
    $0                                    # Install everything
    $0 --phase 00-prerequisites          # Install prerequisites only
    $0 --phase 01-packages,03-symlinks   # Install packages and create symlinks
    $0 --hostname my-macbook              # Set custom hostname

EOF
}

list_phases() {
    echo "Available installation phases:"
    echo ""
    for phase_info in "${PHASES[@]}"; do
        local phase="${phase_info%%:*}"
        local desc="${phase_info##*:}"
        printf "  %-20s - %s\n" "$phase" "$desc"
    done
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -a|--all)
                RUN_ALL_PHASES=true
                shift
                ;;
            -p|--phase)
                RUN_ALL_PHASES=false
                IFS=',' read -ra PHASES_ARG <<< "$2"
                SELECTED_PHASES+=("${PHASES_ARG[@]}")
                shift 2
                ;;
            -l|--list)
                list_phases
                exit 0
                ;;
            -n|--hostname)
                DEFAULT_HOSTNAME="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            *)
                error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

validate_phases() {
    if [[ "$RUN_ALL_PHASES" == false ]]; then
        for selected in "${SELECTED_PHASES[@]}"; do
            local found=false
            for phase_info in "${PHASES[@]}"; do
                local phase="${phase_info%%:*}"
                if [[ "$phase" == "$selected" ]]; then
                    found=true
                    break
                fi
            done
            
            if [[ "$found" == false ]]; then
                error "Invalid phase: $selected"
                echo "Run '$0 --list' to see available phases"
                exit 1
            fi
        done
    fi
}

run_phase() {
    local phase="$1"
    local script="$INSTALL_DIR/$phase.sh"
    
    if [[ ! -f "$script" ]]; then
        error "Phase script not found: $script"
        return 1
    fi
    
    # Make script executable
    chmod +x "$script"
    
    # Run the phase
    info "Running phase: $phase"
    if bash "$script"; then
        success "Phase completed: $phase"
        return 0
    else
        error "Phase failed: $phase"
        return 1
    fi
}

setup_hostname() {
    if [[ "$DEFAULT_HOSTNAME" != "marius-macbook" ]]; then
        info "Setting hostname to: $DEFAULT_HOSTNAME"
        
        if [[ "${DRY_RUN:-false}" == true ]]; then
            info "[DRY RUN] Would set hostname to: $DEFAULT_HOSTNAME"
            return 0
        fi
        
        # Set hostname
        sudo scutil --set HostName "$DEFAULT_HOSTNAME"
        sudo scutil --set LocalHostName "$DEFAULT_HOSTNAME" 
        sudo scutil --set ComputerName "$DEFAULT_HOSTNAME"
        hostname "$DEFAULT_HOSTNAME"
        
        success "Hostname set to: $DEFAULT_HOSTNAME"
    fi
}

show_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🚀 DOTFILES INSTALLER 🚀                          ║
║                                                                              ║
║                     Automated macOS Development Environment                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo ""
}

main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Validate input
    validate_phases
    
    # Show banner
    show_banner
    
    # Show configuration
    info "Installation Configuration:"
    info "  Hostname: $DEFAULT_HOSTNAME"
    if [[ "$RUN_ALL_PHASES" == true ]]; then
        info "  Phases: All phases will be executed"
    else
        info "  Phases: ${SELECTED_PHASES[*]}"
    fi
    
    if [[ "${DRY_RUN:-false}" == true ]]; then
        warning "DRY RUN MODE - No changes will be made"
    fi
    
    echo ""
    
    # Ask for confirmation unless it's a dry run
    if [[ "${DRY_RUN:-false}" != true ]]; then
        read -p "Continue with installation? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            info "Installation cancelled"
            exit 0
        fi
    fi
    
    # Set hostname
    setup_hostname
    
    # Determine which phases to run
    local phases_to_run=()
    if [[ "$RUN_ALL_PHASES" == true ]]; then
        for phase_info in "${PHASES[@]}"; do
            phases_to_run+=("${phase_info%%:*}")
        done
    else
        phases_to_run=("${SELECTED_PHASES[@]}")
    fi
    
    # Run selected phases
    local start_time
    start_time=$(date +%s)
    local failed_phases=()
    
    for phase in "${phases_to_run[@]}"; do
        if [[ "${DRY_RUN:-false}" == true ]]; then
            info "[DRY RUN] Would run phase: $phase"
        else
            if ! run_phase "$phase"; then
                failed_phases+=("$phase")
                warning "Phase failed but continuing with remaining phases"
            fi
        fi
    done
    
    # Show summary
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo ""
    echo "========================================"
    
    if [[ "${DRY_RUN:-false}" == true ]]; then
        info "DRY RUN completed in ${duration}s"
    elif [[ ${#failed_phases[@]} -eq 0 ]]; then
        success "Installation completed successfully in ${duration}s"
        
        # Show next steps for secure config sync
        echo ""
        info "Next steps for secure configuration sync:"
        info "1. Sign in to 1Password: op signin"
        info "2. Set up secure configs: setup-machine"
        info "3. Or backup current configs: sync-configs backup"
        echo ""
        info "Restart your terminal or run: exec zsh"
    else
        warning "Installation completed with ${#failed_phases[@]} failed phases in ${duration}s"
        error "Failed phases: ${failed_phases[*]}"
        exit 1
    fi
}

# Run main function
main "$@"