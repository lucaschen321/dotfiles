" General Configuration
execute pathogen#infect()
"set nocompatible " Disable Vi-compatibility settings
"set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
"set title " Show title in terminal
set number " Show line numbers
set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set wrapscan " Automatically wrap search when hitting bottom
set autoindent " Enable autoindenting
set copyindent " Copy indent of previous line when autoindenting
set history=1000 " Command history
"set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
"set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
"set pastetoggle=<F3> " Toggle paste mode
set mouse=nvc " Allow using mouse to change cursor position in normal, visual,
              " and command line modes
"set timeoutlen=300 " Timeout for entering key combinations
set t_Co=256 " Enable 256 colors
set textwidth=80 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
"set foldmethod=marker " Use vim markers for folding
"set foldnestmax=4 " Maximum nested folds
"set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
"set nofixendofline " Disable automatic adding of EOL
set ruler " Show column in status bar
set colorcolumn=80 " Show vertical column ruler
let mapleader = ' '
let maplocalleader = '\'
syntax enable " Enable syntax highlighting
"filetype indent on " Enable filetype-specific indentation
"filetype plugin on " Enable filetype-specific plugins
"colorscheme default " Set default colors

set background=dark
colorscheme solarized

" Custom mappings
inoremap jj <Esc>
