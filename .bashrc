# Load the platform agnostic shell dotfiles (aliases, etc.)
for file in $HOME/.{shell_exports,shell_aliases,shell_functions,shell_config};
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;


# Load platform specific dotfiles (aliases, etc.)
export OS=""
export DOTFILES_DIR="$(dirname "$(readlink -f "$HOME"/.zshrc)")"

if [[ "$(uname -s)" == "Darwin" ]]; then
    for file in $DOTFILES_DIR/mac/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
    do
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done;
    unset file;
    OS="mac"
    grep -q credential || cat "$DOTFILES_DIR"/shell/mac/.gitconfig >> "$HOME"/.gitconfig
elif [[ "$(uname -s)" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
    for file in $DOTFILES_DIR/ubuntu/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
    do
      [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done;
    unset file;
    OS="ubuntu"
fi

# Load custom dotfiles (uncomment to turn off)
for file in $DOTFILES_DIR/custom/.{shell_exports,shell_aliases,shell_functions,shell_config,bashrc};
do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;

# Remove PATH duplicates, while keeping sort order and earliest appearance
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
export PATH
