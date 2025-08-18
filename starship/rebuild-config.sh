#!/bin/bash
# Rebuild starship configuration with latest GCloud aliases
# Convenient script to refresh starship config when aliases change

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Import utilities
source "$DOTFILES_DIR/install/utils.sh"

main() {
    info "🔄 Rebuilding starship configuration..."
    
    # Check if processing script exists
    if [[ ! -x "$SCRIPT_DIR/process-gcloud-aliases.sh" ]]; then
        error "Processing script not found or not executable: $SCRIPT_DIR/process-gcloud-aliases.sh"
        exit 1
    fi
    
    # First, restore the original starship.toml with placeholder
    info "Restoring original starship.toml..."
    
    # Check if placeholder is missing and add it back
    if ! grep -q "# GCLOUD_PROJECT_ALIASES_PLACEHOLDER" "$SCRIPT_DIR/starship.toml"; then
        # Find the gcloud section and add placeholder after it
        if grep -q "^\[gcloud\]" "$SCRIPT_DIR/starship.toml"; then
            # Create temp file with placeholder added
            local temp_file
            temp_file=$(mktemp)
            
            # Add placeholder after gcloud section
            awk '
                /^\[gcloud\]/ { in_gcloud = 1 }
                in_gcloud && /^$/ { 
                    print "# GCLOUD_PROJECT_ALIASES_PLACEHOLDER"
                    print ""
                    in_gcloud = 0
                    next
                }
                in_gcloud && /^\[/ && !/^\[gcloud/ { 
                    print "# GCLOUD_PROJECT_ALIASES_PLACEHOLDER"
                    print ""
                    in_gcloud = 0
                }
                { print }
            ' "$SCRIPT_DIR/starship.toml" > "$temp_file"
            
            mv "$temp_file" "$SCRIPT_DIR/starship.toml"
            success "✅ Added placeholder to config"
        else
            warning "Could not find gcloud section in config"
        fi
    else
        # Remove any existing aliases to start fresh
        local temp_file
        temp_file=$(mktemp)
        
        # Remove existing aliases between placeholder and next section
        awk '
            /# GCLOUD_PROJECT_ALIASES_PLACEHOLDER/ { 
                print
                placeholder_found = 1
                next
            }
            placeholder_found && /^\[/ && !/^\[gcloud\.project_aliases/ { 
                placeholder_found = 0
                print
                next
            }
            placeholder_found && /^\[gcloud\.project_aliases/ { 
                next
            }
            placeholder_found && /^".*"/ { 
                next
            }
            placeholder_found && /^$/ { 
                next
            }
            { print }
        ' "$SCRIPT_DIR/starship.toml" > "$temp_file"
        
        mv "$temp_file" "$SCRIPT_DIR/starship.toml"
        success "✅ Cleaned existing aliases"
    fi
    
    # Process aliases
    "$SCRIPT_DIR/process-gcloud-aliases.sh"
    
    # Reload starship if it's running
    if command_exists starship; then
        info "Reloading starship configuration..."
        # Starship automatically reloads when config changes
        success "✅ Starship will reload automatically"
    fi
    
    success "🎉 Starship configuration rebuilt!"
    info "Your updated GCloud aliases are now active in the prompt."
}

main "$@"