" General Configuration
execute pathogen#infect()
" set nocompatible " Disable Vi-compatibility settings
" set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
" set title " Show title in terminal
set number " Show line numbers
set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set wrapscan " Automatically wrap search when hitting bottom
set autoindent " Enable autoindenting
set copyindent " Copy indent of previous line when autoindenting
set history=1000 " Command history
" set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
" set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
" set pastetoggle=<F3> " Toggle paste mode
set mouse=nvc " Allow using mouse to change cursor position in normal, visual,
              " and command line modes
" set timeoutlen=300 " Timeout for entering key combinations
set t_Co=256 " Enable 256 colors
" set textwidth=80 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
" set foldmethod=marker " Use vim markers for folding
" set foldnestmax=4 " Maximum nested folds
" set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
" set nofixendofline " Disable automatic adding of EOL
set ruler " Show column in status bar
set colorcolumn=80 " Show vertical column ruler
set wildmenu " Visual autocomplete for command menu
let mapleader = ' '
let maplocalleader = '\'
syntax enable " Enable syntax highlighting
" filetype indent on " Enable filetype-specific indentation
" filetype plugin on " Enable filetype-specific plugins
" colorscheme default " Set default colors
:autocmd InsertEnter,InsertLeave * set cul! " Only highlight current line in normal mode
set noerrorbells visualbell t_vb= " Diable beeps
    if has('autocmd')
      autocmd GUIEnter * set visualbell t_vb=
    endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

set background=dark
colorscheme solarized

" Custom mappings
inoremap jj <Esc> " Map escape to jj  
nnoremap j gj " Move vertically by visual line
nnoremap k gk
inoremap <tab> <c-r>=Smart_TabComplete()<CR>
" nnoremap <esc> :noh<return><esc> "This unsets the "last search pattern" register by hitting return
nnoremap <esc> :noh<return><esc> " Clear highlighting on escape in normal mode
nnoremap <esc>^[ <esc>^[

" Enable [crontab -e] to work with Vim
autocmd filetype crontab setlocal nobackup nowritebackup

" Rename tabs to show tab number. Source: http://superuser.com/a/614424
set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " set the tab page number (for mouse clicks)
                let s .= '%' . (t + 1) . 'T'
                let s .= ' '
                " set page number string
                let s .= t + 1 . ' '
                let n = ''      "temp string for buffer names while we loop and check buftype
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
                        if getbufvar( b, "&buftype" ) == 'help'
                                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                " add modified label [n+] where n pages in tab are modified
                if m > 0
                        let s .= '[' . m . '+]'
                endif
                " select the highlighting for the buffer names
                " my default highlighting only underlines the active tab
                " buffer names.
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " add buffer names
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%999Xclose'
        endif
        return s
endfunction

" Smart mapping for tab completion. Source: http://vim.wikia.com/wiki/VimTip102
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

" NERDTree Configuration
" autocmd vimenter * NERDTree     " Open a NERDTree automatically on vim startup
autocmd StdinReadPre * let s:std_in=1 " open a NERDTree automatically when vim 
                                      " starts up if no files were specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nmap <C-n> :NERDTreeToggle<CR>  "Open NERDTree with Ctrl+n
let NERDTreeShowHidden=1 " Show hidden files by default
let NERDTreeQuitOnOpen=1 " Close automatically when opening/editing a file

 "Use ocp-indent to make autotabbing easyj
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
filetype plugin on " Turn on omni completion
set omnifunc=syntaxcomplete#Complete

" Language settings
" Enable all Python syntax highlighting features
let python_highlight_all = 1

" Enable merlin, an interactive OCaml code analysis plugin, to be used with vim
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
"
" Recommended Syntastic settings for beginners
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5

" Checkers for Syntastic
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_sh_checkers = ['bashate', 'sh', 'shellcheck']
let g:syntastic_vim_checkers = ['vimlint', 'vint']

" Airline settings
let g:airline_theme='solarized'
" let g:solarized_base16 = 1
" let g:airline_solarized_normal_green = 1
" let g:airline_solarized_dark_inactive_border = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

" Vim Session settings
let g:session_autosave = 'no'
