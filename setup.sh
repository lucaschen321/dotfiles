#!/usr/bin/env bash

# https://github.com/nicksp/dotfiles/blob/master/setup.sh

# Get script path; set target directory and backup directory
SCRIPT_PATH=$( cd "$(dirname "$0")" || exit; pwd -P )
DOTFILES_BACKUP_DIR=$HOME/.dotfiles_backup
DOTFILES_DIR=$SCRIPT_PATH

# Color flags for printing
export RESET="\033[0m"
export RED="\033[0;31m"

ask_for_sudo() {
    # Ask for the administrator password upfront
    sudo -v
    
    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done &> /dev/null &
}

# Install zsh 
install_zsh() {
    # Check if zsh is installed. If so:
    if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ] || [ -f /usr/local/bin/zsh ]; then
        # Install oh-my-zsh if it does not exist
        if [ ! -d "$HOME"/.oh-my-zsh ]; then
            echo -e "${RED}Installing oh-my-zsh...${RESET}"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
            echo -e "${RED}Done${RESET}"
        fi

        # Edit $PATH to incorporate brew packages for Mac
        if [ "$(uname -s)" == "darwin" ]; then
            brew_dir="/usr/local/bin"
            paths="/etc/paths"
            echo -e "$brew_dir\n$(cat $paths)" > $paths
        fi
 
         # Add used bash and zsh to /etc/shells if not present
        zsh=$(which zsh)
        bash=$(which bash)
        login_shells=/etc/shells
        grep -q "$bash" "$login_shells" || echo "$bash" >> "$login_shells"
        grep -q "$zsh" "$login_shells" || echo "$zsh" >> "$login_shells"
        
        # Set default shell to zsh
        if [ ! "$SHELL" == "$(which zsh)" ]; then
            echo -e "${RED}Changing default shell to zsh...${RESET}"
            chsh -s "$(which zsh)"
            echo -e "${RED}Done${RESET}"
        fi
    else
        # If zsh is not installed, get OS version of the machine
        system=$(uname -s)
        # Install zsh and recurse
        if [ "$system" == "Darwin" ]; then
            echo -e "${RED} zsh not installed. attempting to zsh using homebrew...${RESET}"
            brew install zsh
            install_zsh
        fi
        if [ "$system" == "Linux" ]; then
           if [ -f /etc/redhat-release ]; then
                sudo apt-get install zsh
                install_zsh
           fi
        fi
    fi
}

install_packages() {
    if [ "$(uname -s)" == "Darwin" ]; then
        "$DOTFILES_DIR"/install/brew.sh
        "$DOTFILES_DIR"/install/brew-cask.sh
    fi
}

symlink_dotfiles() {
    # Change dotfile directory to target directory
    if [ "$SCRIPT_PATH" != "$DOTFILES_DIR" ]; then
        echo -e "${RED}Moving dotfile directory to target destination...${RESET}"
        mv "$SCRIPT_PATH" "$DOTFILES_DIR"
        echo -e "${RED}Done${RESET}"
    fi
    
    FILES_TO_SYMLINK=(
    '.bash_profile'
    '.bashrc'
    '.gitconfig'
    '.shell_aliases'
    '.shell_config'
    '.tmux.conf'
    '.vimrc'
    '.zshrc'
    )
    
    mkdir "$DOTFILES_BACKUP_DIR"

    # Move existing dotfiles to backup directory
    echo -e "${RED}Backing up dotfiles...${RESET}"
    for i in "${FILES_TO_SYMLINK[@]}"; do
        mv "$HOME/${i}" "$DOTFILES_BACKUP_DIR"
    done
    echo -e "${RED}Done${RESET}"

    # Create symlinks in home directory to new dotfiles
    echo -e "${RED}Creating symlinks in home directory to dotfiles...${RESET}"
    for i in "${FILES_TO_SYMLINK[@]}"; do
        ln -s "$DOTFILES_DIR/${i}" "$HOME/${i}"
    done
    echo -e "${RED}Done${RESET}"
}

main(){
    ask_for_sudo
    install_packages
    install_zsh
    symlink_dotfiles
}

main

# Reload zsh settings
# source ~/.zshrc
