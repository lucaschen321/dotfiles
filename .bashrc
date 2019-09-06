export OS=""
export DOTFILES_DIR=""

# Source general, OS-specific and local dotfiles
if [[ "$(uname -s)" == "Darwin" ]]; then
    OS="mac"
    DOTFILES_DIR="$(gdirname "$(realpath -e "$0")")"
elif [[ "$(uname -s)" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
    OS="ubuntu"
    DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"
fi

source "$DOTFILES_DIR"/shell/.bashrc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
