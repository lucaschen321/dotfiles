#!/usr/bin/env bash

# https://github.com/nicksp/dotfiles/blob/master/setup.sh


#
# Variables/Constants
#

# Global variables: SCRIPT_PATH, DOTFILES_BACKUP_DIR, DOTFILES_DIR, OS_NAME

# Get script path; set target directory and backup directory
SCRIPT_PATH=$( cd "$(dirname "$0")" || exit; pwd -P )
DOTFILES_BACKUP_DIR=$HOME/.dotfiles_backup
DOTFILES_DIR=$SCRIPT_PATH

# Update in get_os()
export OS=""

# User's answer {yes|no}
export ANS=""

# Color flags for printing
export RESET="\033[0m"
export RED="\033[0;31m"
export BLUE="\033[0;34m"

#
# Utils/helper functions
#

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

print_error() {
  # Print output in red
  printf "%s  [✖] $1s\n" "${RED}" "${RESET}"
}

print_question() {
    # Print output in yellow
    printf "%s  [?] $1%s\n" "${YELLOW}" "${RESET}";
    read

    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        ANS="yes"
    else
        ANS="no"
    fi
}

print_success() {
  # Print output in green
  printf "%s  [✔] $1%s\n" "${GREEN}" "${RESET}"
}

get_os() {
    OS_UNAME="$(uname -s)"

    if [[ "$OS_UNAME" == "Darwin" ]]; then
        OS="mac"
    elif [[ "$OS_UNAME" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
        OS="ubuntu"
    else
        printf "%s" "asdf"
    fi
}

#
# Actual install
#

# Install zsh
install_zsh() {
    # Check if zsh is installed. If so:
    if [[ -f /bin/zsh  ||  -f /usr/bin/zsh  ||  -f /usr/local/bin/zsh ]]; then
        # Install oh-my-zsh if it does not exist
        if [ ! -d "$HOME"/.oh-my-zsh ]; then
            echo -e "${BLUE}Installing oh-my-zsh...${RESET}"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
            echo -e "${BLUE}Done${RESET}"
        fi

        # Edit /etc/paths to incorporate /usr/local/bin for Mac
        brew_dir=/usr/local/bin
        paths=/etc/paths
        if [[ "$(uname -s)" == "Darwin" ]]; then
          grep -q "$brew_dir" "$paths" || sudo sh -c "echo \"$brew_dir\n$(cat $paths)\" > $paths"
        fi

         # Edit /etc/shells to incorporate installed zsh and bash paths if not present
        zsh=$(which zsh)
        bash=$(which bash)
        login_shells=/etc/shells
        grep -q "$bash" "$login_shells" || sudo sh -c "echo $bash >> $login_shells"
        grep -q "$zsh" "$login_shells" || sudo sh -c "echo $zsh >> $login_shells"

        # Set default shell to zsh
        if [ ! "$SHELL" == "$(which zsh)" ]; then
            echo -e "${BLUE}Changing default shell to zsh...${RESET}"
            chsh -s "$(which zsh)"
            echo -e "${BLUE}Done${RESET}"
        fi
    else
        echo -e "${BLUE}zsh not installed. Attempting to install zsh...${RESET}"
        # If zsh is not installed, get OS version of the machine
        system=$(uname -s)
        # Install zsh and recurse
        if [ "$system" == "Darwin" ]; then
            brew install zsh
            install_zsh
        fi
        if [ "$system" == "Linux" ]; then
           if [ -f /etc/redhat-release ]; then
                sudo apt-get install zsh
                install_zsh
           fi
        fi
        echo -e "${BLUE}Done${RESET}"
    fi
}

install_packages() {
    if [ "$(uname -s)" == "Darwin" ]; then
        "$DOTFILES_DIR"/install/brew.sh
        "$DOTFILES_DIR"/install/brew-cask.sh
    fi
}

install_vim_and_tmux_plugins() {

    #
    # Install Vim Plugins:
    #
    # - Pathogen (Plugin manager)
    # - Solarized
    # - NerdTree
    # - Syntastic
    # - Airline

    echo -e "${BLUE}Installing vim plugins...${RESET}"

    # Install Pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # Install Solarized
    git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized

    # Install NerdTree
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

    # Install Syntastic
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic

    # Install Airline
    git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
    git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes

    # Install Vim Session
    git clone https://github.com/xolox/vim-session.git ~/.vim/bundle/vim-session
    git clone https://github.com/xolox/vim-misc.git ~/.vim/bundle/vim-misc

    # Install Vim Notes
    git clone https://github.com/xolox/vim-notes.git ~/.vim/bundle/vim-notes

    # Install Surround.vim
    git clone git://github.com/tpope/vim-surround.git

    echo -e "${BLUE}Done${RESET}"

    #
    # Install Tmux plugins (see ~/.tmux.conf for plugins)
    #

    echo -e "${BLUE}Installing tmux plugins...${RESET}"

    # Install Tmux plugin manager and load plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    tmux run-shell "$HOME"/.tmux/plugins/tpm/bindings/install_plugins

    echo -e "${BLUE}Done${RESET}"

}

symlink_dotfiles() {
    # Change dotfile directory to target directory
    if [ "$SCRIPT_PATH" != "$DOTFILES_DIR" ]; then
        echo -e "${BLUE}Moving dotfile directory to target destination...${RESET}"
        mv "$SCRIPT_PATH" "$DOTFILES_DIR"
        echo -e "${BLUE}Done${RESET}"
    fi

    FILES_TO_SYMLINK=(
        '.bash_profile'
        '.bashrc'
        '.gitconfig'
        '.shell_aliases'
        '.shell_config'
        '.shell_exports'
        '.shell_functions'
        '.tmux.conf'
        '.vimrc'
        '.zshrc'
    )

    mkdir "$DOTFILES_BACKUP_DIR"

    # Move existing dotfiles to backup directory
    echo -e "${BLUE}Backing up dotfiles...${RESET}"
    for i in "${FILES_TO_SYMLINK[@]}"; do
        mv "$HOME/${i}" "$DOTFILES_BACKUP_DIR"
    done
    echo -e "${BLUE}Done${RESET}"

    # Create symlinks in home directory to new dotfiles
    echo -e "${BLUE}Creating symlinks in home directory to dotfiles...${RESET}"
    for i in "${FILES_TO_SYMLINK[@]}"; do
        ln -s "$DOTFILES_DIR/${i}" "$HOME/${i}"
    done
    echo -e "${BLUE}Done${RESET}"
}

main(){
    ask_for_sudo
    install_packages
    install_zsh
    symlink_dotfiles
    install_vim_and_tmux_plugins
}

main

# Reload zsh settings
# source ~/.zshrc
