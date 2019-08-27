#!/usr/bin/env bash

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
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export PURPLE="\033[0;35m"

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
  printf "%b  [✖] $1%b\n" "${RED}" "${RESET}"
}

print_question() {
    # Print output in yellow
    printf "%b  [?] $1%b\n" "${YELLOW}" "${RESET}";
    read

    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        ANS="yes"
    else
        ANS="no"
    fi
}

print_info() {
  # Print info in purple
  printf "%b  $1%b\n" "${PURPLE}" "${RESET}"
}

print_success() {
  # Print output in green
  printf "%b  [✔] $1%b\n" "${GREEN}" "${RESET}"
}

get_os() {
    OS_UNAME="$(uname -s)"

    if [[ "$OS_UNAME" == "Darwin" ]]; then
        OS="mac"
    elif [[ "$OS_UNAME" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
        OS="ubuntu"
    else
        print_error "Setup script not compatible with OS"
        exit 1
    fi
}

update_submodules() {
    print_info "Updating submodules...."
    git submodule init
    git submodule update
}

#
# Actual install
#

# Install zsh
install_zsh() {
    # Check if zsh is installed. If so:
    which zsh &> /dev/null
    if [[ $? == 0 ]]; then
         # Install zsh plugins: zsh-autosuggestions, zsh-syntax-highlighting
         update_submodules

        # Edit /etc/shells to incorporate installed zsh path if not present
        zsh=$(which zsh)
        login_shells=/etc/shells
        grep -q "$zsh" "$login_shells" || sudo sh -c "echo $zsh >> $login_shells"

        # Set default shell to zsh
        if [ ! "$SHELL" == "$(which zsh)" ]; then
            print_info "Changing default shell to zsh"
            chsh -s "$(which zsh)"
            print_success "Done"
        fi
    else
        print_info "zsh not installed. Attempting to install zsh"
        # Attempt to install zsh and recurse
        if [ "$OS" == "mac" ]; then
            brew install zsh
            install_zsh
        fi
        if [ "$OS" == "ubuntu" ]; then
            sudo apt-get install zsh
            install_zsh
        fi
        print_success "Done"
    fi
}

# Install bash
install_bash() {
    # Install most recent bash version on mac if not present
    if [[ "$OS" == "mac" && ! -e /usr/local/bin/bash ]]; then
        print_info "Installing brew's bash"
        brew install bash
        print_success "Done"
    fi

    # Edit /etc/shells to incorporate installed bash path if not present
    bash=$(which bash)
    login_shells=/etc/shells
    grep -q "$bash" "$login_shells" || sudo sh -c "echo $bash >> $login_shells"

    # Set default shell to bash
    if [ ! "$SHELL" == "$(which zsh)" ]; then
        print_info "Changing default shell to bash"
        chsh -s "$(which bash)"
        print_success "Done"
    fi
}

install_shell() {
    # Install zsh and bash
    print_question "Use zsh? (y/n)"
    if [[ "$ANS" == "yes" ]]; then
        install_zsh
    else
        print_question "Use bash? (y/n)"
        if [[ "$ANS" == "yes" ]]; then
            install_bash
        else
            print_error "Choose bash or zsh...exiting"
            exit 1
        fi
    fi
}

install_packages() {
    print_question "Install packages? (y/n)"
    if [[ "$ANS" == "yes" ]]; then
        if [ "$OS" == "mac" ]; then
            which brew &> /dev/null
            if [[ $? != 0 ]]; then
                # Install Homebrew
                print_info "Installing homebrew"
                ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                print_success "Done"

                # Edit /etc/paths to incorporate /usr/local/bin for Mac
                brew_dir=/usr/local/bin
                paths=/etc/paths
                if [[ "$OS" == "mac" ]]; then
                    grep -q "$brew_dir" "$paths" || sudo sh -c "echo \"$brew_dir\n$(cat $paths)\" > $paths"
                fi
            else
                brew update
            fi
            "$DOTFILES_DIR"/install/brew.sh
            "$DOTFILES_DIR"/install/brew-cask.sh
        elif [[ "$OS" == "ubuntu" ]]; then
            "$DOTFILES_DIR"/install/apt-get.sh
        fi
    fi
}

install_vim_and_tmux_plugins() {

    #
    # Install Vim Plugins (see ~/.vimrc for plugins):
    #
    print_question "Install vim plugins? (y/n)"
    if [[ "$ANS" == "yes" ]]; then
        print_info "Installing vim plugins"

        # Install Vim Plug
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

        print_success "Done"
    fi

    #
    # Install Tmux plugins (see ~/.tmux.conf for plugins)
    #
    print_question "Install tmux plugins? (y/n)"
    if [[ "$ANS" == "yes" ]]; then

        print_info "Installing tmux plugins"

        # Install Tmux plugin manager and load plugins
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
        tmux run-shell "$HOME"/.tmux/plugins/tpm/bindings/install_plugins

        print_success "Done"
    fi

}

symlink_dotfiles() {
    print_question "Symlink dotfiles? (y/n)"
    if [[ "$ANS" == "yes" ]]; then
        # Change dotfile directory to target directory
        if [ "$SCRIPT_PATH" != "$DOTFILES_DIR" ]; then
            print_info "Moving dotfile directory to target destination"
            mv "$SCRIPT_PATH" "$DOTFILES_DIR"
            print_success "Done"
        fi


        # File in SOURCE_FILES_TO_SYMLINK array **MUST** match corresponding
        # file in TARGET_FILES_TO_SYMLINK array
        SOURCE_FILES_TO_SYMLINK=(
            "$DOTFILES_DIR/.bash_profile"
            "$DOTFILES_DIR/.bashrc"
            "$DOTFILES_DIR/.gitconfig"
            "$DOTFILES_DIR/.shell_aliases"
            "$DOTFILES_DIR/.shell_config"
            "$DOTFILES_DIR/.shell_exports"
            "$DOTFILES_DIR/.shell_functions"
            "$DOTFILES_DIR/.tmux.conf"
            "$DOTFILES_DIR/.vimrc"
            "$DOTFILES_DIR/.zshrc"
            "$DOTFILES_DIR/shell/local/.shell_exports.local"
            "$DOTFILES_DIR/shell/local/.shell_aliases.local"
            "$DOTFILES_DIR/shell/local/.shell_functions.local"
            "$DOTFILES_DIR/shell/local/.shell_config.local"
            "$DOTFILES_DIR/shell/local/.bashrc.local"
            "$DOTFILES_DIR/shell/local/.gitconfig.local"
            "$DOTFILES_DIR/submodules/zsh" # Symlink .zsh directory
        )
        TARGET_FILES_TO_SYMLINK=(
            "$HOME/.bash_profile"
            "$HOME/.bashrc"
            "$HOME/.gitconfig"
            "$HOME/.shell_aliases"
            "$HOME/.shell_config"
            "$HOME/.shell_exports"
            "$HOME/.shell_functions"
            "$HOME/.tmux.conf"
            "$HOME/.vimrc"
            "$HOME/.zshrc"
            "$HOME/.shell_exports.local"
            "$HOME/.shell_aliases.local"
            "$HOME/.shell_functions.local"
            "$HOME/.shell_config.local"
            "$HOME/.bashrc.local"
            "$HOME/.gitconfig.local"
            "$HOME/.zsh"
        )

        if [[ ! -e "$DOTFILES_BACKUP_DIR" ]]; then
            mkdir "$DOTFILES_BACKUP_DIR"
        fi

        # Move existing dotfiles to backup directory
        print_info "Backing up dotfiles"
        for file in "${TARGET_FILES_TO_SYMLINK[@]}"; do
            if [[ -e "${file}" ]]; then
                mv "${file}" "$DOTFILES_BACKUP_DIR"
            fi
        done
        print_success "Done"

        # Create symlinks in home directory to new dotfiles
        print_info "Creating symlinks in home directory to dotfiles"
        for i in $(seq 1 ${#TARGET_FILES_TO_SYMLINK[@]}); do
            if [[ -e "${SOURCE_FILES_TO_SYMLINK[i]}" ]]; then
                ln -s "${SOURCE_FILES_TO_SYMLINK[i]}"  "${TARGET_FILES_TO_SYMLINK[i]}"
            fi
        done

        print_success "Done"
    fi
}

main(){
    ask_for_sudo
    get_os
    install_packages
    install_vim_and_tmux_plugins
    install_shell
    symlink_dotfiles
}

main
