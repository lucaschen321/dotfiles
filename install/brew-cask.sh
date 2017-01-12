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

brew cask install "${apps[@]}"
