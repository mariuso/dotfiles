# 🚀 Marius's Dotfiles

Automated macOS development environment setup with secure configuration sync.

## ⚡ Quick Start (New Mac)

```bash
git clone https://github.com/mariuso/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./quick-install.sh
```

This single command will:
- ✅ Install Xcode Command Line Tools
- ✅ Install Homebrew
- ✅ Install all packages and applications
- ✅ Configure shell environment (zsh with starship prompt)
- ✅ Set up development tools
- ✅ Configure macOS settings
- ✅ Set up secure config sync with 1Password

## 🔐 Secure Config Sync

Sensitive configs (SSH, AWS, GCloud, etc.) are stored securely in 1Password:

```bash
# Sign in to 1Password
op signin

# Set up all configs on new machine
setup-machine

# Backup configs to 1Password
sync-configs backup

# Restore configs from 1Password
sync-configs restore

# List available configs
sync-configs list
```

## 📦 What's Included

### Development Tools
- **Languages**: Node.js, Python, Java, Go
- **Cloud**: AWS CLI, Google Cloud SDK, Docker
- **Kubernetes**: kubectl, k9s
- **Databases**: MySQL client, Redis
- **Version Control**: Git, GitHub CLI

### Applications
- **Terminals**: iTerm2, Ghostty
- **Editors**: VS Code, Neovim
- **Productivity**: Alfred, Maccy, Arc browser, Spotify
- **Cloud Storage**: Transmit
- **Security**: 1Password

### Shell Environment
- **Shell**: Zsh with custom configuration
- **Prompt**: Starship prompt
- **Enhancements**: Auto-suggestions, prefix history search
- **Aliases**: Extensive collection for productivity

## 🛠️ Manual Installation

If you prefer step-by-step installation:

```bash
# Clone the repository
git clone https://github.com/mariuso/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run full installation
./install.sh

# Or run specific phases
./install.sh --phase 01-packages,03-symlinks
./install.sh --list  # See available phases
```

## 🐧 Linux Hosts

On a Linux machine (e.g. a remote dev VM), only the portable configs are
linked; programs are expected to be installed by the host's provisioning:

```bash
git clone https://github.com/mariuso/dotfiles.git ~/.dotfiles
~/.dotfiles/install-linux.sh
```

## 📁 Repository Structure

```
.dotfiles/
├── install-remote.sh       # One-liner installer
├── install.sh             # Main installation script (macOS)
├── install-linux.sh       # Link portable configs on Linux hosts
├── Brewfile               # Homebrew packages and apps
├── install/               # Modular installation scripts
│   ├── 00-prerequisites.sh
│   ├── 01-packages.sh
│   ├── 02-shell-setup.sh
│   ├── 03-symlinks.sh
│   ├── 04-macos-config.sh
│   ├── 05-development.sh
│   └── 06-post-install.sh
├── secure-configs/        # Secure config sync system
│   ├── sync-configs.sh    # Main sync script
│   ├── setup-machine.sh   # New machine setup
│   └── README.md          # Secure sync documentation
├── shell/                 # Shell configuration
│   ├── .zshrc             # macOS
│   ├── .zshrc.linux       # Linux
│   ├── common.zsh         # Shared by both
│   ├── aliases.zsh
│   ├── exports.zsh        # macOS environment
│   └── functions.zsh
├── nvim/                  # Neovim configuration
├── starship/              # Starship prompt (+ private GCloud aliases)
├── ghostty/               # Ghostty terminal
├── ssh/                   # SSH configuration
│   └── config.template
├── dnsmasq/              # Local DNS configuration
│   └── domains.txt.example
├── vscode/               # VS Code settings
└── themes/               # Terminal themes
```

## 🔧 Secure Configuration Files

These sensitive configs are managed through 1Password:

- `~/.ssh/config` - SSH client configuration
- `~/.aws/credentials` - AWS access keys
- `~/.config/gcloud/` - Google Cloud credentials
- `~/.kube/config` - Kubernetes cluster access
- `~/.docker/config.json` - Docker registry auth
- `~/.terraformrc` - Terraform credentials
- `~/.npmrc` - NPM registry tokens

## 🎯 Key Features

### Security First
- **No credentials in git** - All sensitive data in 1Password
- **Encrypted storage** - 1Password vault encryption
- **Audit trail** - Track config access and changes
- **Machine-specific configs** - SSH configs tagged by hostname

### Productivity Focused
- **Fast setup** - One command to complete environment
- **Shell shortcuts** - Extensive aliases and functions
- **Development ready** - All major languages and tools
- **Cloud native** - Kubernetes, Docker, cloud providers

### Maintainable
- **Modular design** - Separate installation phases
- **Portable scripts** - Compatible across bash versions
- **Documentation** - Clear usage instructions
- **Version controlled** - Track all changes

## 📝 Customization

### Adding New Packages
Edit `Brewfile` and run:
```bash
./install.sh --phase 01-packages
```

### Adding New Configs
Edit `secure-configs/sync-configs.sh` CONFIG_MAPPINGS array:
```bash
CONFIG_MAPPINGS+=("$HOME/.myapp/config|My App Config")
```

### Shell Customization
Edit files in `shell/` directory:
- `aliases.zsh` - Command shortcuts
- `functions.zsh` - Custom shell functions  
- `exports.zsh` - macOS environment variables
- `common.zsh` - Settings shared with Linux

### dnsmasq Configuration
Local development domains setup:
1. Copy template for first-time setup:
   ```bash
   cp install/dnsmasq.sh.template install/dnsmasq.sh
   ```
2. Add custom domains by copying the example:
   ```bash
   cp dnsmasq/domains.txt.example dnsmasq/domains.txt
   ```
3. Edit `dnsmasq/domains.txt` with your domains (one per line, optionally followed by an IP)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Feel free to fork this repository and customize it for your own needs. Pull requests for improvements are welcome!