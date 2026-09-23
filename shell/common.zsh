# Shared zsh settings
# Sourced by both .zshrc (macOS) and .zshrc.linux

export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
export LESS='-R'
export DEV_DIR="$HOME/Developer"

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
setopt COMPLETE_ALIASES

# Up/down search history by the typed prefix
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

SHELL_DIR="$HOME/.dotfiles/shell"
[[ -f "$SHELL_DIR/aliases.zsh" ]] && source "$SHELL_DIR/aliases.zsh"
[[ -f "$SHELL_DIR/functions.zsh" ]] && source "$SHELL_DIR/functions.zsh"
