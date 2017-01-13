#!/usr/bin/env bash
# Installs casks from brew

# Color flags for printing
export RESET="\033[0m"
export RED="\033[0;31m"

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/versions

# Install packages
apps=(
    dropbox
    iterm2
    google-chrome
    google-drive
    spotify
    slack
    sublime-text
)

echo -e "${RED}Installing default apps...${RESET}"
brew cask install "${apps[@]}"
echo -e "${RED}Done${RESET}"
