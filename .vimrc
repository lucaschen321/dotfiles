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
set foldmethod=marker " Use vim markers for folding
" set foldnestmax=4 " Maximum nested folds
" set noshowmatch " Do not temporarily jump to match when inserting an end brace
" set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
" set nofixendofline " Disable automatic adding of EOL
set ruler " Show column in status bar
set colorcolumn=80 " Show vertical column ruler
set wildmenu " Visual autocomplete for command menu
set clipboard=unnamed
let mapleader = ' '
let maplocalleader = '\'
syntax enable " Enable syntax highlighting
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins
colorscheme default " Set default colors
" set background=dark
hi CursorLine cterm=none ctermbg=235
hi ColorColumn cterm=bold ctermbg=235
hi LineNr ctermfg=grey
" autocmd InsertEnter,InsertLeave * set cul! " Only highlight current line in normal mode
set noerrorbells visualbell t_vb= " Diable beeps
    if has('autocmd')
      autocmd GUIEnter * set visualbell t_vb=
    endif
autocmd BufWinLeave *.* mkview " Save folds
autocmd BufWinEnter *.* silent loadview
highlight Todo ctermbg=NONE ctermfg=13

" Autocommands
augroup defaults
    " Clear augroup
    autocmd!
     " Execute runtime configurations for plugins
    autocmd VimEnter * call PluginConfig()
    " StripTrailingWhitespaces
    autocmd BufWrite <buffer> :call StripTrailingWhitespaces()
    " Enable [crontab -e] to work with Vim
    autocmd filetype crontab setlocal nobackup nowritebackup
    autocmd InsertEnter * call plug#load('YouCompleteMe')
                     \| call youcompleteme#Enable() | autocmd! load_ycm
augroup END
" }}}
" Custom mappings {{{
function! s:SetMappings()
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
    nnoremap <esc> :noh<return><esc>  " Clear highlighting on escape in normal mode
    nnoremap <CR> :noh<CR><CR>  " Clear hlsearch using Return/Enter
    " Allow saving when forgetting to start vim with sudo
    cmap w!! w !sudo tee > /dev/null %
    nnoremap <esc>^[ <esc>^[

    " Easy system clipboard copy/paste
    vnoremap <C-c> "+y
    vnoremap <C-x> "+x
    inoremap <C-v> <Left><C-o>"+p

    " Use Control + (hjkl) to mimic arrow keys for navigating menus in insert mode
    inoremap <C-k> <Up>
    inoremap <C-j> <Down>
    inoremap <C-h> <Left>
    inoremap <C-l> <Right>

    " Easy page up/down
    nnoremap <C-Up> <C-u>
    nnoremap <C-Down> <C-d>
    nnoremap <C-k> 3k
    nnoremap <C-j> 3j
    vnoremap <C-k> 3k
    vnoremap <C-j> 3j

    " HTML
    " imap </ </<C-X><C-O>

endfunction
call s:SetMappings()
" }}}
" Custom functions {{{
function! DeflateWhitespace(string)
    let i = 0
    let newString = ""
    while i < len(a:string)
        if a:string[i] == " "
            let newString .= " "
            while a:string[i] == " "
                let i += 1
            endwhile
        endif
        let newString .= a:string[i]
        let i += 1
    endwhile
    return newString
endfunction

" Automatically remove trailing whitespaces
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e         " delete trailing whitspaces
    call cursor(l, c)   " return cursor to previous position
endfunction

" This function is called by autocmd when vim starts
function! PluginConfig()
    " Javacomplete config {{{
        function! s:InitJavaComplete()
            setlocal omnifunc=javacomplete#Complete
        endfunction
        augroup javacomplete
            autocmd Filetype java call s:InitJavaComplete()
        augroup END
        if &filetype ==? 'java'
            call s:InitJavaComplete()
        endif
    "}}}
endfunction

" }}}
" Plugins {{{

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

        " Install indentLine
        Plug 'Yggdroot/indentLine'

        " Install fzf
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

        " Ultisnips
        Plug 'SirVer/ultisnips'

        " Vim-snippets
        Plug 'honza/vim-snippets'

        " Tcomment
        Plug 'tomtom/tcomment_vim'

        " YCM
        Plug 'Valloric/YouCompleteMe'

        " Vim-complete
        " Plug 'ajh17/VimCompletesMe'

        "delimitMate
        Plug 'Raimondi/delimitMate'

        " javacomplete
        Plug 'artur-shaik/vim-javacomplete2', {
            \'for': 'java'
        \}

        " Install jedi-vim
        Plug 'davidhalter/jedi-vim', {
                \'for': 'python'
            \}
call plug#end()
" }}}
" Plugin Configurations {{{
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
let g:syntastic_check_on_open = 0
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

" " YouCompleteMe Settings
" let g:loaded_youcompleteme = 1 " Don't load YCM
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
 let g:ycm_register_as_syntastic_checker = 0
" Don't show ycm checker
let g:ycm_show_diagnostics_ui = 0
" let g:ycm_global_ycm_extra_conf = 0
" let g:ycm_confirm_extra_conf=0
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" Lazy load YCM
augroup load_ycm
augroup END

" If 1, then menu won't display for 1 letter snippets - must be expanded using
" expand trigger
let g:ycm_min_num_of_chars_for_completion = 2
let g:ulti_expand_or_jump_res = 0


" Indent Line Settings
let g:indentLine_char = '┆'"
let g:indentLine_color_term = 248

" Ultisnips
" set runtimepath+=$DOTFILES_DIR/lib/
" let g:UltiSnipsSnippetDirectories=["snippets_custom"]
let g:UltiSnipsExpandTrigger = "<LocalLeader><Tab>"
let g:UltiSnipsListSnippets = "<LocalLeader><LocalLeader>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
let g:UltiSnipsEditSplit="vertical"

function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>"

" Jedi
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0

" }}}
" tabline from StackOverflow (with auto-resizing modifications) {{{
set tabline+=%!MyTabLine()
function! MyTabLine()
    let tabline = ''
    " Iterate through each tab page
    let numTabs = tabpagenr('$')
    let currentTab = tabpagenr()
    let winWidth = 0
    for winNr in range(winnr('$'))
        let w = winwidth(winNr + 1)
        if w > winWidth
            let winWidth = w
        endif
    endfor
    let maxTabsDisplayed = winWidth / 20
    let LRPadding = maxTabsDisplayed / 2
    let evenOddOffset = (maxTabsDisplayed % 2 == 0) ? 0 : 1
    for tabIndex in range(numTabs)
        let tabIndex += 1
        let upperBound = (currentTab < LRPadding) ? LRPadding + (LRPadding - currentTab) : LRPadding
        let upperBound += evenOddOffset
        if numTabs > maxTabsDisplayed && maxTabsDisplayed > 1
            " Lower (left) bound for tab listing
            if tabIndex < currentTab - LRPadding + 1
                continue
            " Upper (right) bound for tab listing
            elseif tabIndex > currentTab + upperBound
                continue
            endif
        " If maxTabsDisplayed is 0, then only show the current tab
        elseif maxTabsDisplayed <= 1 && tabIndex != currentTab
            continue
        endif
        " Set highlight for tab
        if tabIndex == currentTab
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Set the tab page number (for mouse clicks)
        let tabline .= '%' . (tabIndex) . 'T'
        let tabline .= ' '
        " Set page number string
        let tabline .= tabIndex . ' '
        " Get buffer names and statuses
        let tmp = '' " Temp string for buffer names while we loop and check buftype
        let numModified = 0 " &modified counter
        let bufsRemaining = len(tabpagebuflist(tabIndex)) " Counter to avoid last ' '
        " Iterate through each buffer in the tab
        for bufIndex in tabpagebuflist(tabIndex)
            let currentBufName = bufname(bufIndex)
            " Use a variable to keep track of whether a new name was added
            let newBufNameAdded = 1
            " Special buffer types: [Q] for quickfix, [H]{base fname} for help
            if getbufvar(bufIndex, "&buftype") == 'help'
                let tmp .= '[H]' . fnamemodify(currentBufName, ':t:s/.txt$//')
            elseif getbufvar(bufIndex, "&buftype") == 'quickfix'
                let tmp .= '[Q]'
            else
                " Do not show plugin-handled windows in the bufferlist
                if (currentBufName =~# "NERD"
                \|| currentBufName =~# "Gundo"
                \|| currentBufName =~# "__Tagbar__")
                    let newBufNameAdded = 0
                else
                    let tmp .= pathshorten(fnamemodify(currentBufName, ':~:.'))
                endif
            endif
            " Check and increment tab's &modified count
            if getbufvar(bufIndex, "&modified")
                let numModified += 1
            endif
            " Add trailing ' ' if necessary
            if bufsRemaining > 1 && newBufNameAdded == 1
                let tmp .= ' '
            endif
            let bufsRemaining -= 1
        endfor
        " Add modified label [n+] where n pages in tab are modified
        if numModified > 0
            let tabline .= '[' . numModified . '+]'
        endif
        " Select the highlighting for the buffer names
        if tabIndex == currentTab
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Add buffer names
        if tmp == ''
            let tabline .= '[New]'
        else
            let tabline .= tmp
        endif
        " Add trailing ' ' for tab
        let tabline .= ' '
    endfor
    " Remove excess whitespace
    let tabline = DeflateWhitespace(tabline)
    " After the last tab fill with TabLineFill, and reset tab page number to
    " support mouse clicks
    let tabline .= '%#TabLineFill#%T'
    " Add close button
    if numTabs > 1
        " Right-align the label to close the current tab page
        let tabline .= '%=%#TabLineFill#%999X%#Red_196#Close%##'
    endif
    return tabline
endfunction
" }}}
