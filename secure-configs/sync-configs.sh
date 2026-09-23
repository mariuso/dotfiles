#!/bin/bash
# Secure Config Sync Script using 1Password
# Syncs sensitive configuration files across machines securely

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
MACHINE_NAME="$(hostname -s)"

# Import utilities
source "$DOTFILES_DIR/install/utils.sh"

# Config mappings: local_path|1password_item_title
CONFIG_MAPPINGS=(
    "$HOME/.ssh/config|SSH Config - $MACHINE_NAME"
    "$HOME/.aws/credentials|AWS Credentials"
    "$HOME/.aws/config|AWS Config"
    "$HOME/.config/gcloud/application_default_credentials.json|GCloud ADC"
    "$HOME/.kube/config|Kubernetes Config"
    "$HOME/.docker/config.json|Docker Config"
    "$HOME/.terraformrc|Terraform Config"
    "$HOME/.config/op/config|1Password CLI Config"
    "$HOME/.npmrc|NPM Config"
    "$HOME/.config/sops/age/keys.txt|SOPS Age Keys"
    "$DOTFILES_DIR/starship/starship_gcloud_aliases.toml.template|Starship GCloud Aliases Template"
)

# Vault name for storing configs
VAULT_NAME="Development Configs"

check_prerequisites() {
    if ! command_exists op; then
        error "1Password CLI not found. Install with: brew install 1password-cli"
        exit 1
    fi
    
    if ! op account list &>/dev/null; then
        error "Not signed in to 1Password. Run: op signin"
        exit 1
    fi
    
    info "✅ Prerequisites check passed"
}

create_vault_if_needed() {
    if ! op vault list --format=json | jq -e ".[] | select(.name == \"$VAULT_NAME\")" &>/dev/null; then
        info "Creating vault: $VAULT_NAME"
        op vault create "$VAULT_NAME"
    fi
}

sync_config_to_1password() {
    local file_path="$1"
    local item_title="$2"
    
    if [[ ! -f "$file_path" ]]; then
        warning "Config file not found: $file_path"
        return 0
    fi
    
    info "📤 Uploading: $(basename "$file_path")"
    
    # Check if item exists
    if op item get "$item_title" --vault="$VAULT_NAME" &>/dev/null; then
        # Update existing item
        op document edit "$item_title" "$file_path" --vault="$VAULT_NAME"
    else
        # Create new item
        op document create "$file_path" --title="$item_title" --vault="$VAULT_NAME" \
            --tags="dotfiles,config,$(basename "$file_path"),machine:$MACHINE_NAME"
    fi
    
    success "✅ Synced: $item_title"
}

sync_config_from_1password() {
    local file_path="$1"
    local item_title="$2"
    
    info "📥 Downloading: $(basename "$file_path")"
    
    if ! op item get "$item_title" --vault="$VAULT_NAME" &>/dev/null; then
        warning "Config not found in 1Password: $item_title"
        return 0
    fi
    
    # Ensure directory exists
    ensure_dir "$(dirname "$file_path")"
    
    # Download and set proper permissions
    op document get "$item_title" --vault="$VAULT_NAME" --output="$file_path"
    
    # Set restrictive permissions for sensitive files
    if [[ "$file_path" == *".ssh/"* ]] || [[ "$file_path" == *"credentials"* ]] || [[ "$file_path" == *"sops/age/keys"* ]]; then
        chmod 600 "$file_path"
    else
        chmod 644 "$file_path"
    fi
    
    success "✅ Downloaded: $item_title"
}

backup_configs() {
    info "🔐 Backing up configs to 1Password..."
    create_vault_if_needed
    
    for mapping in "${CONFIG_MAPPINGS[@]}"; do
        local file_path="${mapping%|*}"
        local item_title="${mapping#*|}"
        sync_config_to_1password "$file_path" "$item_title"
    done
    
    success "🎉 Backup complete!"
}

restore_configs() {
    info "📦 Restoring configs from 1Password..."
    
    for mapping in "${CONFIG_MAPPINGS[@]}"; do
        local file_path="${mapping%|*}"
        local item_title="${mapping#*|}"
        
        if [[ -f "$file_path" ]]; then
            read -p "⚠️  File exists: $file_path. Overwrite? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                info "Skipping: $(basename "$file_path")"
                continue
            fi
        fi
        
        sync_config_from_1password "$file_path" "$item_title"
    done
    
    success "🎉 Restore complete!"
}

list_configs() {
    info "📋 Available configs in 1Password:"
    
    for mapping in "${CONFIG_MAPPINGS[@]}"; do
        local file_path="${mapping%|*}"
        local item_title="${mapping#*|}"
        
        if op item get "$item_title" --vault="$VAULT_NAME" &>/dev/null; then
            local modified=$(op item get "$item_title" --vault="$VAULT_NAME" --format=json | jq -r '.updated_at')
            echo "  ✅ $item_title (modified: $modified)"
        else
            echo "  ❌ $item_title (not found)"
        fi
    done
}

show_usage() {
    cat << EOF
Usage: $0 [COMMAND]

Secure configuration file sync using 1Password

Commands:
    backup      Upload local configs to 1Password
    restore     Download configs from 1Password to local machine
    list        Show available configs in 1Password
    help        Show this help message

Examples:
    $0 backup      # Upload all configs to 1Password
    $0 restore     # Download all configs from 1Password
    $0 list        # Show what's stored in 1Password

Configuration files managed:
EOF
    
    for mapping in "${CONFIG_MAPPINGS[@]}"; do
        local file_path="${mapping%|*}"
        local item_title="${mapping#*|}"
        echo "  • $(basename "$file_path") → $item_title"
    done
}

main() {
    check_prerequisites
    
    case "${1:-help}" in
        backup)
            backup_configs
            ;;
        restore)
            restore_configs
            ;;
        list)
            list_configs
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            error "Unknown command: ${1:-}"
            echo
            show_usage
            exit 1
            ;;
    esac
}

main "$@"