#!/bin/bash
# Installs casks from brew

# Install Caskroom
brew tap caskroom/cask
brew tap caskroom/versions

# Install packages
apps=(
    dropbox
    flux
    iterm2
    google-chrome
    spotify
    skype
    slack
    sublime-text
)

brew cask install "${apps[@]}"
