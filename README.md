# Lucas Chen's Dotfiles
![Terminal.app](https://github.com/lucaschen321/Dotfiles/blob/master/iTerm/Terminal.png "iTerm Screenshot")

These are dotfiles and scripts that I use to customize the software development tools I use. They should be cloned to `~/.dotfiles/`. A setup script is also included.

The setup script will back up existing dotfiles to `~/.dotfiles_backup/` and create symlinks from the home directory to the appropriate files in `~/.dotfiles/`. I prefer `zsh`, so the script will also install the `oh-my-zsh` repository, and change the default shell to run `zsh`. The Vim plugins that I use are also installed. If run on macOS, some common Homebrew formulae are installed. 

## Installation
	git clone https://github.com/lucaschen321/Dotfiles.git ~/.dotfiles
	cd ~/.dotfiles
	chmod +x setup.sh
	./setup.sh

## Features
- zsh aliases
- Git aliases
- [Install script](https://github.com/lucaschen321/Dotfiles/blob/master/setup.sh)
- Automatic Software installation

## Resources
I watch the following respositories and add the best changes to this respository.

- [Guide to Dotfiles on Github] (http://dotfiles.github.io/)
- [Chesley Tan's Dotfiles] (https://github.com/ChesleyTan/linuxrc/)
- [Nick Plekhanov's Dotfiles] (https://github.com/nicksp/dotfiles)
