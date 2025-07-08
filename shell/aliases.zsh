# Shell Aliases
# Common command shortcuts and replacements

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Listing files
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -G'  # Enable colors on macOS

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'

# Lazydocker
alias lzd='lazydocker'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'

# Terraform shortcuts
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

# Development tools
alias vim='nvim'
alias vi='nvim'
alias oldvim='vim'
alias python='python3'
alias pip='pip3'

# Utilities
alias reload='source ~/.zshrc'
alias dotfiles='cd ~/.dotfiles'
alias brewup='brew update && brew upgrade && brew cleanup'
alias myip='curl -s http://checkip.amazonaws.com/'
alias localip='ipconfig getifaddr en0'

# macOS specific
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'

# Quick directory access
alias dev='cd ~/Developer'
alias work='cd ~/Developer/Work'
alias personal='cd ~/Developer/Private'
