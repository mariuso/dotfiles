#!/bin/bash
# Process GCloud aliases into starship configuration
# Merges gcloud project aliases from template into main starship.toml

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARSHIP_CONFIG="$SCRIPT_DIR/starship.toml"
ALIASES_TEMPLATE="$SCRIPT_DIR/starship_gcloud_aliases.toml.template"
PLACEHOLDER="# GCLOUD_PROJECT_ALIASES_PLACEHOLDER"

# Import utilities
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
source "$DOTFILES_DIR/install/utils.sh"

check_files() {
    if [[ ! -f "$STARSHIP_CONFIG" ]]; then
        error "Starship config not found: $STARSHIP_CONFIG"
        exit 1
    fi
    
    if [[ ! -f "$ALIASES_TEMPLATE" ]]; then
        warning "GCloud aliases template not found: $ALIASES_TEMPLATE"
        info "Proceeding without gcloud aliases"
        return 1
    fi
    
    return 0
}

process_aliases() {
    info "🔄 Processing GCloud aliases into starship config..."
    
    # Check if placeholder exists
    if ! grep -q "$PLACEHOLDER" "$STARSHIP_CONFIG"; then
        warning "Placeholder not found in starship config"
        info "Expected: $PLACEHOLDER"
        return 1
    fi
    
    # Create temporary file with processed content
    local temp_file
    temp_file=$(mktemp)
    
    # Process the config line by line
    while IFS= read -r line; do
        if [[ "$line" == "$PLACEHOLDER" ]]; then
            # Insert aliases from template, skip comments and empty lines
            grep -v '^#' "$ALIASES_TEMPLATE" | grep -v '^$' >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$STARSHIP_CONFIG"
    
    # Move processed file back
    mv "$temp_file" "$STARSHIP_CONFIG"
    
    success "✅ GCloud aliases processed successfully"
    
    # Show what was added
    info "Added aliases:"
    grep -v '^#' "$ALIASES_TEMPLATE" | grep -v '^$' | grep -E '^\[|=' | while read -r line; do
        echo "  $line"
    done
    
    return 0
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Process GCloud aliases from template into starship configuration.

Options:
    -h, --help    Show this help message
    -v, --verbose Enable verbose output

Files:
    Config:   $STARSHIP_CONFIG
    Template: $ALIASES_TEMPLATE
    
The script replaces the placeholder '$PLACEHOLDER' 
in the starship config with the contents of the aliases template.
EOF
}

main() {
    case "${1:-}" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -v|--verbose)
            set -x
            ;;
        "")
            # Normal processing
            ;;
        *)
            error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    
    if check_files; then
        process_aliases
    else
        info "Skipping GCloud aliases processing"
    fi
}

main "$@"