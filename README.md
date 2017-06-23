# Lucas Chen's Dotfiles

![Terminal.app](https://github.com/lucaschen321/dotfiles/blob/master/iTerm/Terminal.png "iTerm Screenshot")

These are dotfiles and scripts that I use to customize the software development tools I use. The dotfiles and setup script written are designed to be fully compatible with both **macOS** and **Linux (Debian)** - (tested on macOS Sierra version 10.12.5 and Ubuntu 16.04.2 LTS).

The setup script gives the option for:

- Installing packages (using brew on macOS and apt-get on Debian)
- Installing vim and tmux plugins:
  - Vim
    - [Pathogen (plugin manager)](https://github.com/tpope/vim-pathogen)
    - [Solarized](https://github.com/altercation/vim-colors-solarized)
    - [NerdTree](https://github.com/scrooloose/nerdtree)
    - [Syntastic](https://github.com/vim-syntastic/syntastic)
    - [Airline](https://github.com/vim-airline/vim-airline)
    - [Vim Session](https://github.com/xolox/vim-session)
    - [Vim Notes](https://github.com/xolox/vim-notes)
    - [Surround.vim](https://github.com/tpope/vim-surround)
    - [Repeat.vim](https://github.com/tpope/vim-repeat)
  - Tmux
    - [Tpm (plugin manager)](https://github.com/tmux-plugins/tpm)
    - [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
    - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- Choosing the shell (z/ba)sh. Will change the default shell. (zsh will install oh-my-zsh, my customizations, and plugins).
  - oh-my-zsh plugins
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- Symlinking dotfiles. Will back up existing dotfiles to `~/.dotfiles_backup/` and create symlinks from the home directory to the appropriate files in `~/.dotfiles/`.

## Installation

- Clone this repository somewhere on your machine (this guide assumes ~/.dotfiles) and run the setup script.

``` sh
git clone https://github.com/lucaschen321/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x setup.sh
./setup.sh
```

## Features

- zsh aliases
- Git aliases
- [Install script](https://github.com/lucaschen321/dotfiles/blob/master/setup.sh)
- Automatic Software installation
- Local customization
  - OS specific dotfiles in `~/.dotfiles/shell/{mac|ubuntu}`
  - Local custom dotfiles in `~/.dotfiles/shell/custom`
  - Creates local `~/.gitconfig.local` for sensitive information like `git` credentials. It is included after `~/.gitconfig`, allowing its content to overwrite existing configurations

## Resources

I watch the following respositories and add the best changes to this respository.

- [Guide to Dotfiles on Github](http://dotfiles.github.io/)
- [Chesley Tan's Dotfiles](https://github.com/ChesleyTan/linuxrc/)
- [Nick Plekhanov's Dotfiles](https://github.com/nicksp/dotfiles)
