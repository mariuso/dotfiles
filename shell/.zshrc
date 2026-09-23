# Zsh Configuration (macOS)
# Shared settings live in common.zsh; macOS-specific environment in exports.zsh

SHELL_DIR="$HOME/.dotfiles/shell"

# Load exports first so Homebrew is on PATH and HOMEBREW_PREFIX is set
[[ -f "$SHELL_DIR/exports.zsh" ]] && source "$SHELL_DIR/exports.zsh"

# Homebrew completions must be on FPATH before oh-my-zsh runs compinit
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

# Oh My Zsh (runs compinit)
export ZSH="$HOME/.oh-my-zsh"
plugins=(git colored-man-pages command-not-found npm z)
source $ZSH/oh-my-zsh.sh

# Shared settings, aliases and functions (after oh-my-zsh so they win)
[[ -f "$SHELL_DIR/common.zsh" ]] && source "$SHELL_DIR/common.zsh"

setopt HIST_BEEP

# Zsh autosuggestions
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# iTerm2 shell integration
[[ -f "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# Google Cloud SDK
GCLOUD_SDK="$HOMEBREW_PREFIX/Caskroom/gcloud-cli/latest/google-cloud-sdk"
[[ -f "$GCLOUD_SDK/path.zsh.inc" ]] && source "$GCLOUD_SDK/path.zsh.inc"
[[ -f "$GCLOUD_SDK/completion.zsh.inc" ]] && source "$GCLOUD_SDK/completion.zsh.inc"

# Terraform completion
if command -v terraform >/dev/null 2>&1; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C "$(command -v terraform)" terraform
fi

# 1Password CLI plugins
[[ -f "$HOME/.config/op/plugins.sh" ]] && source "$HOME/.config/op/plugins.sh"

# Starship prompt (must be at the end)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
