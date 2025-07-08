#!/bin/bash

echo "Start automated installer"

HOSTNAME="horseface"

diskutil rename / ecitpro

echo "This script will set properties on OSX"

echo " Ask for the administrator password for the duration of this script"
sudo -v

echo " Keep-alive: update existing sudo time stamp until .osx has finished"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Setup sudo with touch id
bash ./macos/enable-sudo-touchid.sh

scutil --set HostName $HOSTNAME
scutil --set HostName $HOSTNAME
scutil --set HostName $HOSTNAME
hostname $HOSTNAME

echo " Installing Xcode Command Line Tools"

xcode-select --install

echo " Installing Homebrew ..."

echo $(pwd)

bash ./install/homebrew.sh

echo " Installing mise-en-place version manager."
bash ./install/mise-en-place.sh

bash ./install/setup-terminal.sh
bash ./macos/macos-defaults.sh
