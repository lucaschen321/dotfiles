# General configuration {{{
HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=99999
SAVEHIST=99999
setopt INC_APPEND_HISTORY # Append history as commands are executed
setopt HIST_IGNORE_DUPS # Don't save duplicates
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# use cache when auto-completing
zstyle ':completion::complete:*' use-cache 1
# use case-insensitive auto-completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# graphical auto-complete menu
zstyle ':completion:*' menu select

# Colored cd tab complete
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C


# Tetris :)
autoload -U tetris
zle -N tetris
bindkey ^Y tetris

export ZSH=$HOME/.zsh

# Get dotfiles directory path
if [[ "$(uname -s)" == "Darwin" ]]; then
    export OS="mac"
    export DOTFILES_DIR="$(gdirname "$(realpath -e "$HOME"/.zshrc)")"
elif [[ "$(uname -s)" == "Linux" && "$(lsb_release -si)" == "Ubuntu" ]]; then
    export OS="ubuntu"
    export DOTFILES_DIR="$(dirname "$(readlink -f "$HOME"/.zshrc)")"
fi
# }}}
# Prompt {{{
# Use robbyrussell theme
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    # If SSHed
    PS1='%{$fg[white]%}(%M) %{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
else
    # Not SSH
    PS1='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
fi

# Load prompt functions (Must go before prompt functions)
autoload -U colors && colors
setopt promptsubst

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
# }}}
# Color Support {{{
# LS_COLORS
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31'
# }}}
# Terminal Vim {{{
# Terminal Vim key bindings
bindkey -v
# bindkey '^P' up-history
bindkey -s '^P' '$EDITOR $(fzf)\n'
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M viins 'jj' vi-cmd-mode
export KEYTIMEOUT=100

# Enable command line edit with v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Indicate Vim mode in Terminal
vim_ins_mode="%{$fg[blue]%}[-- INSERT --]%{$reset_color%}"
vim_cmd_mode="%{$fg[green]%}[-- NORMAL --]%{$reset_color%}"
vim_mode=$vim_ins_mode
function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select
function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}
RPROMPT='${vim_mode}'
# }}}
# Plugin configuration {{{
if [[ "$ZSH_SYNTAX_HIGHLIGHTING_PLUGIN" == "" ]]; then
    source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_PLUGIN=1
fi

if [[ "$ZSH_AUTOSUGGESTIONS_PLUGIN" = "" ]]; then
    source $ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow"
    ZSH_AUTOSUGGESTIONS_PLUGIN=1
fi

if [[ "$ZSH_Z_PLUGIN" = "" ]]; then
    source "$DOTFILES_DIR"/lib/z.sh
    ZSH_Z_PLUGIN=1
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# }}}
# Source general, OS-specific and local dotfiles {{{
source "$DOTFILES_DIR"/shell/.bashrc
# }}}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
