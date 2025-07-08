#!/bin/bash


## Setup folders
mkdir ~/Developer
mkdir ~/Developer/Work
mkdir ~/Developer/Private
mkdir ~/Developer/Infrastructure
mkdir ~/Documents/Screenshots
mkdir ~/Work
mkdir ~/.themes
mkdir ~/.tmp-installers

echo $(pwd)

echo " Sync themes"
rsync -avh --no-perms ./themes/ ~/.themes

cd ~/.tmp-installers

curl -fsSL -o install-ohmyzsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
bash install-ohmyzsh.sh --unattended

cd -

source ~/.zprofile

# Add stuff to zsh
source "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

## Add homeserver
# Should maybe install dockutil
# dockutil --add  '/Applications/iTerm.app' --replacing 'iTerm' --after 'Photos'

# ASFD - Everything related to plugins, versions and more

## Setup asdf with python, node, yarn, bun
bash ./asdf-setup.sh

bash ./dnsmasq.sh


## Fetch personal settings
rm -rf ~/.zshrc
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

rm -rf ~/.gitconfig
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig

rm -rf ~/.gitignore
ln -s ~/.dotfiles/git/.gitignore ~/.gitignore

rm -rf ~/.config/starship.toml
ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

# Setup Ghostty configuration
mkdir -p ~/.config/ghostty
rm -rf ~/.config/ghostty/config
ln -s ~/.dotfiles/ghostty/config ~/.config/ghostty/config

#Symlink OpenJDK
# sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
sudo ln -sfn $HOMEBREW_PREFIX/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

## Authenticate with github
gh auth login

op signin

op plugin init vultr-cli
