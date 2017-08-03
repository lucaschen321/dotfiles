#!/usr/bin/env bash
# Installs Homebrew and some of the common dependencies needed/desired for software development

# Color flags for printing
export RESET="\033[0m"
export RED="\033[0;31m"

# Ask for the administrator password upfront
sudo -v

# Make sure we’re using the latest Homebrew
sudo apt-get update

# Upgrade any already-installed formulae
sudo apt-get upgrade

packages=(
    # Checkers
    checkstyle
    make
    shellcheck

    # Utilities
    curl
    git
    pandoc
    tmux
    unity-tweak-tool
    redshift
    redshift-gtk
    silversearcher-ag
    xsel

    # Languages/Frameworks
    nginx
    npm
    mysql
)

echo -e "${RED}Installing packages...${RESET}"
sudo apt-get install "${packages[@]}"

# Remove outdated versions from the cellar
sudo apt-get clean

echo -e "${RED}Done${RESET}"
