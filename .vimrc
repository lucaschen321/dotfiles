" General Configuration {{{
execute pathogen#infect()
set nocompatible " Disable Vi-compatibility settings
" set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
set title " Show title in terminal
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
colorscheme default " Set default colors
" set background=dark
hi CursorLine cterm=none ctermbg=235
hi ColorColumn cterm=bold ctermbg=235
hi LineNr ctermfg=grey
autocmd InsertEnter,InsertLeave * set cul! " Only highlight current line in normal mode
set noerrorbells visualbell t_vb= " Diable beeps
    if has('autocmd')
      autocmd GUIEnter * set visualbell t_vb=
    endif
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
" }}}


" Automatically remove trailing whitespaces
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e         " delete trailing whitspaces
    call cursor(l, c)   " return cursor to previous position
endfunction
autocmd BufWrite <buffer> :call StripTrailingWhitespaces()


" Custom mappings {{{
function! SetMappings()
    inoremap jj <Esc>
    nnoremap j gj " Move vertically by visual line
    nnoremap k gk
    vnoremap j gj
    vnoremap k gk
    nnoremap <Down> gj
    nnoremap <Up> gk
    vnoremap <Down> gj
    vnoremap <Up> gk
    inoremap <Down> <C-o>gj
    inoremap <Up> <C-o>gk
    inoremap <tab> <c-r>=Smart_TabComplete()<CR>
    " nnoremap <esc> :noh<return><esc> "This unsets the "last search pattern" register by hitting return
    nnoremap <esc> :noh<return><esc> " Clear highlighting on escape in normal mode
    " Clear hlsearch using Return/Enter
    nnoremap <CR> :noh<CR><CR>
    " Allow saving when forgetting to start vim with sudo
    cmap w!! w !sudo tee > /dev/null %
    nnoremap <esc>^[ <esc>^[

    " Easy system clipboard copy/paste
    vnoremap <C-c> "+y
    vnoremap <C-x> "+x
    inoremap <C-v> <Left><C-o>"+p

    " Easy page up/down
    " nnoremap <C-Up> <C-u>
    " nnoremap <C-Down> <C-d>
    " nnoremap <C-k> 3k
    " nnoremap <C-j> 3j
    " vnoremap <C-k> 3k
    " vnoremap <C-j> 3j
endfunction
" }}}
"
" Enable [crontab -e] to work with Vim
autocmd filetype crontab setlocal nobackup nowritebackup

" HTML
imap </ </<C-X><C-O>

" function! ConditionalPairMap(open, close)
"   let line = getline('.')
"   let col = col('.')
"   if col < col('$') || stridx(line, a:close, col + 1) != -1
"     return a:open
"   else
"     return a:open . a:close . repeat("\<left>", len(a:close))
"   endif
" endf
" inoremap <expr> ( ConditionalPairMap('(', ')')
" inoremap <expr> { ConditionalPairMap('{', '}')
" inoremap <expr> [ ConditionalPairMap('[', ']')

inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j0f}a"
 endif
endf

function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf


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


" Pre-start function calls (non-autocommand) {{{
" if has("gui_running")
"     call Custom()
" elseif empty($DISPLAY) "If running in a tty, use solarized theme for better colors
"     call Solarized()
" else
"     call Custom()
" endif
call SetMappings()


" Plugin Configurations {{{

" Vim Plug
call plug#begin('~/.vim/plugged')

        " Install NerdTree
        Plug 'scrooloose/nerdtree'

        " Install Syntastic
        Plug 'vim-syntastic/syntastic'

        " Install Airline
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        " Install Vim Session
        Plug 'xolox/vim-session'
        Plug 'xolox/vim-misc'

        " Install Vim Notes
        Plug 'xolox/vim-notes'

        " Install Surround.vim
        Plug 'tpope/vim-surround'

        " Install Vim-Indent-Guides
        Plug 'nathanaelkane/vim-indent-guides'

        " Install fzf
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

        " Ultisnips
        Plug 'SirVer/ultisnips'

        " Vim-snippets
        Plug 'honza/vim-snippets'

        " Tcomment
        Plug 'tomtom/tcomment_vim'

        " Vim-complete
        Plug 'ajh17/VimCompletesMe'

call plug#end()

" NERDTree Configuration
" autocmd vimenter * NERDTree     " Open a NERDTree automatically on vim startup
" autocmd StdinReadPre * let s:std_in=1 " open a NERDTree automatically when vim
                                      " starts up if no files were specified
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nmap <C-n> :NERDTreeToggle<CR>  "Open NERDTree with Ctrl+n
let NERDTreeShowHidden=1 " Show hidden files by default
let NERDTreeQuitOnOpen=1 " Close automatically when opening/editing a file
map <Leader>n <plug>NERDTreeTabsToggle<CR> " Open NERDTree with <CTRL+n>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif "Close vim if the only window left open is a NERDTree

" NERDTree Tabs
let g:nerdtree_tabs_open_on_gui_startup = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_open_on_new_tab = 1
let g:nerdtree_tabs_meaningful_tab_names = 1
let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_synchronize_view = 1
let g:nerdtree_tabs_synchronize_focus = 1

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

let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic -Wno-sign-compare"
" Checkers for Syntastic
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_sh_checkers = ['bashate', 'sh', 'shellcheck']
let g:syntastic_c_checkers = ['gcc', 'make']
let g:syntastic_vim_checkers = ['vimlint', 'vint']
let g:syntastic_java_checkers = ['checkstyle', 'javac']
let g:syntastic_markdown_checkers = ['mdl']

" Airline settings
 let g:airline_theme='onedark'
" let g:airline_theme='tomorrow'
" let g:solarized_base16 = 1
" let g:airline_solarized_normal_green = 1
" let g:airline_solarized_dark_inactive_border = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

" Vim Session settings
let g:session_autosave = 'no'

" Vim Notes settings
let g:notes_directories = ['~/Google Drive/Documents/Notes/Vim Notes'] ", '~/Google Drive/Documents/Notes/Text Notes/CS/Programming Langauges']
let g:notes_tab_indents = 0
let g:notes_conceal_url = 0

" YouCompleteMe Settings
" let g:loaded_youcompleteme = 0 " Don't load YCM
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_show_diagnostics_ui = 1
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
 let g:ycm_register_as_syntastic_checker = 0
" Don't show ycm checker
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = 0
" let g:ycm_confirm_extra_conf=0

" If 1, then menu won't display for 1 letter snippets - must be expanded using
" expand trigger
let g:ycm_min_num_of_chars_for_completion = 2
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>"

" Indent Guides Settings
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=grey

" Ultisnips
" set runtimepath+=$DOTFILES_DIR/bin/
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["snippets_custom"]

let g:UltiSnipsEditSplit="vertical"

"}}}
