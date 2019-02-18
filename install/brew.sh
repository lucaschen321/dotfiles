#!/usr/bin/env bash

# Installs Homebrew and some of the common dependencies needed/desired for software development

# Color flags and print functions

print_info() {
  # Print info in purple
  printf "%s  $1s\n" "${RED}" "${RESET}"
}

print_success() {
  # Print output in green
  printf "%s  [✔] $1%s\n" "${GREEN}" "${RESET}"
}

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if [ ! -f "$(command -v brew)" ]; then
  echo "${RED}Installing Homebrew...${RESET}"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "${RED}Done${RESET}"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# List of Homebrew packages

formulae=(
    awk
    bash
    bash-completion2
    cmake
    curl
    fzf
    gcc
    gcc@7
    gdbm
    git
    git-extras
    grep
    htop
    llvm
    make
    mongodb
    neofetch
    ocaml
    ocamlbuild
    octave
    opam
    opencv
    openssh
    pandoc
    perl
    python
    python@2
    reattach-to-user-namespace
    ruby
    source-highlight
    the_silver_searcher
    tmux
    tree
    vim
    wget
    youtube-dl # Download youtube videos
    zsh
    zsh-syntax-highlighting

    # Checkers
    checkstyle
    flake8
    shellcheck

    # GNU Command Line Tools
    coreutils
    diffutils
    findutils
    gawk
    gnu-getopt
    gnu-indent
    gnu-sed
    gnu-tar
    gnu-which
    gnutls
    gzip
)

echo -e "${RED}Installing homebrew packages...${RESET}"
brew install "${formulae[@]}"

# Remove outdated versions from the cellar
brew cleanup

echo -e "${RED}Done${RESET}"
