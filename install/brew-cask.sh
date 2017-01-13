#!/bin/bash
# Installs casks from brew

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
