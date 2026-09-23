# Environment Variables and Exports
# Path configuration and environment setup

# Homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# mise-en-place version manager
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# Java configuration
export JAVA_HOME="$(brew --prefix)/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export CPPFLAGS="-I$(brew --prefix)/opt/openjdk@21/include"
export PATH="$(brew --prefix)/opt/openjdk@21/bin:$PATH"

# MySQL client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# LibXML2
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"

# Python user packages
export PATH="$PATH:$HOME/Library/Python/3.9/lib/python/site-packages"

# Go
export PATH="$(go env GOPATH)/bin:$PATH" 2>/dev/null || true
export PATH="$PATH:$HOME/go/bin"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Ruby (rbenv)
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

# Editor preferences
export EDITOR='nvim'
export VISUAL='nvim'

# History configuration
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Less configuration
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# Disable macOS session restore warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Development directories
export DEV_DIR="$HOME/Developer"
export WORK_DIR="$HOME/Developer/Work"
export PERSONAL_DIR="$HOME/Developer/Private"

# SOPS (secrets management)
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
