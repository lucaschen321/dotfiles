" General Configuration
execute pathogen#infect()
set number " Show line numbers
set wrap " Wrap lines
set linebreak " Break line on word
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set backspace=indent,eol,start " Allow full functionality of backspace
set ruler " Show column in status bar
set colorcolumn=80 " Show vertical column ruler

syntax enable " Enable syntax highlighting

set background=dark
colorscheme solarized

" Custom mappings
inoremap jj <Esc>
