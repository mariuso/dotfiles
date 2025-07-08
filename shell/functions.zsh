# Shell Functions
# Custom functions for enhanced productivity

# Secure config management
sync-configs() {
    "$HOME/.dotfiles/secure-configs/sync-configs.sh" "$@"
}

setup-machine() {
    "$HOME/.dotfiles/secure-configs/setup-machine.sh" "$@"
}

# Kubernetes namespace switching
kn() {
    if [ "$1" != "" ]; then
        kubectl config set-context --current --namespace=$1
        echo "Switched to namespace: $1"
    else
        echo -e "\e[1;31mError: Please provide a valid namespace\e[0m"
        echo "Usage: kn <namespace>"
    fi
}

# Switch to default namespace
knd() {
    kubectl config set-context --current --namespace=default
    echo "Switched to default namespace"
}

# Unset current Kubernetes context
ku() {
    kubectl config unset current-context
    echo "Unset current Kubernetes context"
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find and kill processes by name
killp() {
    if [ "$1" = "" ]; then
        echo "Usage: killp <process_name>"
        return 1
    fi
    
    local pids=$(pgrep -f "$1")
    if [ -n "$pids" ]; then
        echo "Found processes:"
        ps -p $pids -o pid,comm,args
        echo
        read "response?Kill these processes? [y/N]: "
        if [[ $response =~ ^[Yy]$ ]]; then
            kill $pids
            echo "Processes killed"
        else
            echo "Cancelled"
        fi
    else
        echo "No processes found matching: $1"
    fi
}

# Quick file search
ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

# Quick directory search
fd() {
    find . -type d -name "*$1*" 2>/dev/null
}

# Git clone and cd
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Create a new git repository
ginit() {
    git init
    git add .
    git commit -m "Initial commit"
    if [ "$1" != "" ]; then
        git remote add origin "$1"
        echo "Remote 'origin' added: $1"
        echo "Run 'git push -u origin main' to push to remote"
    fi
}

# Weather function
weather() {
    local city="${1:-Oslo}"
    curl -s "wttr.in/${city}?format=3"
}

# Create a backup of a file
backup() {
    if [ -f "$1" ]; then
        cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: ${1}.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File not found: $1"
    fi
}

# Show disk usage of current directory
duh() {
    du -sh * | sort -hr
}

# Quick serve current directory over HTTP
serve() {
    local port="${1:-8000}"
    echo "Serving current directory on http://localhost:$port"
    python3 -m http.server "$port"
}

# Generate a random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 $length | tr -d "=+/" | cut -c1-$length
}

# Show listening ports
ports() {
    lsof -iTCP -sTCP:LISTEN -n -P
}

# Docker cleanup
dcleanup() {
    echo "Cleaning up Docker containers, images, and volumes..."
    docker container prune -f
    docker image prune -f
    docker volume prune -f
    docker network prune -f
    echo "Docker cleanup complete"
}

# Update all tools
update-all() {
    echo "🍺 Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
    
    if command -v mise >/dev/null 2>&1; then
        echo "🔧 Updating mise tools..."
        mise upgrade
    fi
    
    if command -v npm >/dev/null 2>&1; then
        echo "📦 Updating npm global packages..."
        npm update -g
    fi
    
    echo "✅ All updates complete!"
}