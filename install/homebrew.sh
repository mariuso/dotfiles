#!/bin/bash

echo "Start automated brew installer"

brewInstalls=(
  moreutils
  findutils
  gnupg
  grep
  lima
  zsh
  mise
  bat
  caddy
  doctl
  git
  gh
  kubernetes-cli
  vultr
  k9s
  openjdk@21
  redis
  saxon
  tree
  ssh-copy-id
  font-monaspace
  starship
  dnsmasq
  fanny
  cloud-sql-proxy
  zsh-autosuggestions
  ansible
  vultr/vultr-cli/vultr-cli
  awscli
  neovim
  maven
  planetscale/tap/pscale
  mysql-client
  stripe-cli
  jesseduffield/lazydocker/lazydocker
)

brewCasks=(
  iterm2
  maccy
  visual-studio-code
  bruno
  google-chrome
  spotify
  arc
  docker
  slack
  alfred
  tailscale
  1password
  1password-cli
  google-cloud-sdk
  microsoft-teams
  microsoft-word
  microsoft-excel
  microsoft-remote-desktop
  transmit
  tableplus
  font-meslo-lg-nerd-font
  logi-options-plus
)

vscode=(
  Catppuccin.catppuccin-vsc
  Catppuccin.catppuccin-vsc-icons
  GitHub.copilot
  GitHub.copilot-chat
  Vue.volar
  Vue.vscode-typescript-vue-plugin
  Nuxtr.nuxtr-vscode
  bradlc.vscode-tailwindcss
  antfu.iconify
  usernamehw.errorlens
)

if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
    /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

echo "Updating Homebrew formulae ..."
brew update --force
brew upgrade

# Clear Brewfile
echo "" > ./Brewfile
echo "tap \"1password/tap\"" >> ./Brewfile
echo "tap \"hashicorp/tap\"" >> ./Brewfile
echo "tap \"homebrew/bundle\"" >> ./Brewfile
echo "tap \"homebrew/cask-versions\"" >> ./Brewfile
echo "tap \"planetscale/tap\"" >> ./Brewfile
echo "tap \"homebrew/cask-fonts\"" >> ./Brewfile
echo "tap \"oven-sh/bun\"" >> ./Brewfile

for i in "${brewInstalls[@]}"
do
	echo "Add $i to Brewfile"
  echo "brew \"$i\"" >> ./Brewfile
done

for i in "${brewCasks[@]}"
do
	echo "Add cask $i to Brewfile"
  echo "cask \"$i\"" >> ./Brewfile
done

for i in "${vscode[@]}"
do
	echo "Add vscode $i to Brewfile"
  echo "vscode \"$i\"" >> ./Brewfile
done

brew bundle --file=Brewfile
brew cleanup
