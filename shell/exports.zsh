# Environment Variables and Exports (macOS)
# Shared exports (editor, history, ~/.local/bin) live in common.zsh

# Homebrew
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

# mise-en-place version manager
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# Java configuration
export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openjdk@21/include"
export PATH="$HOMEBREW_PREFIX/opt/openjdk@21/bin:$PATH"

# MySQL client
export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"

# LibXML2
export PATH="$HOMEBREW_PREFIX/opt/libxml2/bin:$PATH"

# Go
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

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Disable macOS session restore warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Development directories
export WORK_DIR="$HOME/Developer/Work"
export PERSONAL_DIR="$HOME/Developer/Private"

# SOPS (secrets management)
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
