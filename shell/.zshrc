# Zsh Configuration
# Modular setup for enhanced shell experience

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh configuration
plugins=(git colored-man-pages command-not-found npm z mise)
source $ZSH/oh-my-zsh.sh

# Load modular configuration files
SHELL_DIR="$HOME/.dotfiles/shell"

# Load exports (environment variables and PATH)
[[ -f "$SHELL_DIR/exports.zsh" ]] && source "$SHELL_DIR/exports.zsh"

# Load aliases
[[ -f "$SHELL_DIR/aliases.zsh" ]] && source "$SHELL_DIR/aliases.zsh"

# Load functions
[[ -f "$SHELL_DIR/functions.zsh" ]] && source "$SHELL_DIR/functions.zsh"

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Starship prompt (must be at the end)
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Homebrew completion system
if command -v brew >/dev/null 2>&1; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
    FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
    
    # Zsh autosuggestions
    if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
    
    autoload -Uz compinit
    compinit
fi

# Google Cloud SDK completion
if [[ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

if [[ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# Terraform completion
if command -v terraform >/dev/null 2>&1; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

# Additional completions
autoload -Uz colors; colors

# 1Password CLI completion (if available)
if [[ -f "$HOME/.config/op/plugins.sh" ]]; then
    source "$HOME/.config/op/plugins.sh"
fi

# History configuration
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
setopt COMPLETE_ALIASES

# Custom key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# opencode
export PATH="$HOME/.opencode/bin:$PATH"
