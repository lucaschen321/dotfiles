export OS=""
export DOTFILES_DIR=""

# Source general, OS-specific and custom dotfiles
if [[ "$(uname -s)" == "Darwin" ]]; then
    OS="mac"
    DOTFILES_DIR="$(gdirname "$(realpath -e "$HOME"/.zshrc)")"
elif [[ "$(uname -s)" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
    OS="ubuntu"
    DOTFILES_DIR="$(dirname "$(readlink -f "$HOME"/.zshrc)")"
fi

source "$DOTFILES_DIR"/shell/.bashrc
