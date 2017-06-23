# Load the platform agnostic shell dotfiles (aliases, etc.)
for file in $HOME/.{shell_exports,shell_aliases,shell_functions,shell_config};
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;


# Load platform specific dotfiles (aliases, etc.)
export OS=""
export DOTFILES_DIR="$(dirname "$(readlink -f "$HOME"/.zshrc)")"

if [[ ! -f "$HOME"/.gitconfig.local ]]; then
    cat "$DOTFILES_DIR"/shell/custom/.gitconfig >> "$HOME"/.gitconfig.local
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    for file in "$DOTFILES_DIR"/mac/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
    do
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done;
    unset file;
    grep -q credential "$HOME"/.gitconfig.local || cat "$DOTFILES_DIR"/shell/mac/.gitconfig >> "$HOME"/.gitconfig.local
    OS="mac"
elif [[ "$(uname -s)" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
    for file in "$DOTFILES_DIR"/ubuntu/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
    do
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done;
    unset file;
    grep -q credential "$HOME"/.gitconfig.local || cat "$DOTFILES_DIR"/shell/ubuntu/.gitconfig >> "$HOME"/.gitconfig.local
    OS="ubuntu"
fi

# Load custom dotfiles (uncomment to turn off)
for file in "$DOTFILES_DIR"/custom/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;

# Remove PATH duplicates, while keeping sort order and earliest appearance
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
export PATH

# Use colors for ls (customizes $LS_COLORS)
force_color_prompt=yes
eval "$(dircolors "$DOTFILES_DIR"/bin/dircolors)"
