export OS=""
export DOTFILES_DIR="$(dirname "$(readlink -f "$HOME"/.bashrc)")"

# Source general, OS-specific and custom dotfiles
source $DOTFILES_DIR/shell/.bashrc
