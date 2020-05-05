" General Configuration {{{
set nocompatible " Disable Vi-compatibility settings
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
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
set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
" set pastetoggle=<F3> " Toggle paste mode
set mouse=nvc " Allow using mouse to change cursor position in normal, visual,
              " and command line modes
set timeoutlen=400 " Timeout for entering key combinations
set t_Co=256 " Enable 256 colors
set textwidth=0 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set foldmethod=manual " Use vim markers for folding
set foldnestmax=4 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set ttyfast
set re=1 "force the old regex engine on any version newer
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
hi CursorLine cterm=none ctermbg=235
hi ColorColumn cterm=bold ctermbg=235
hi LineNr ctermfg=grey
" autocmd InsertEnter,InsertLeave * set cul! " Only highlight current line in normal mode
set noerrorbells visualbell t_vb= " Diable beeps
    if has('autocmd')
      autocmd GUIEnter * set visualbell t_vb=
    endif
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
    " autocmd InsertEnter * call plug#load('YouCompleteMe')
    "                  \| call youcompleteme#Enable()
    " Save folds
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent loadview
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

    " Quick toggle fold method
    nnoremap <Leader>tf :call ToggleFoldMethod()<CR>
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

function! ToggleFoldMethod()
    if &foldmethod ==? "manual"
        setlocal foldmethod=indent
    elseif &foldmethod ==? "indent"
        setlocal foldmethod=expr
    elseif &foldmethod ==? "expr"
        setlocal foldmethod=marker
    elseif &foldmethod ==? "marker"
        setlocal foldmethod=syntax
    elseif &foldmethod ==? "syntax"
        setlocal foldmethod=diff
    elseif &foldmethod ==? "diff"
        setlocal foldmethod=manual
    endif
    echo "Fold method set to: " . &foldmethod
endfunction

let g:original_conceallevel=&conceallevel
function! ToggleConceal()
    if &conceallevel == 0
        let &conceallevel=g:original_conceallevel
    else
        let g:original_conceallevel=&conceallevel
        set conceallevel=0
    endif
endfunction
command! ToggleConceal call ToggleConceal()
" }}}
" Plugins {{{

" Vim Plug
call plug#begin('~/.vim/plugged')

        " Install NerdTree
        " Plug 'scrooloose/nerdtree', {
        "     \'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeTabsToggle']
        " \}

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
        Plug 'junegunn/fzf.vim'

        " Ultisnips
        Plug 'SirVer/ultisnips'

        " Vim-snippets
        Plug 'honza/vim-snippets'

        " Tcomment
        Plug 'tomtom/tcomment_vim'

        " YCM
        Plug 'Valloric/YouCompleteMe'

        " Install YCM-Generator
        Plug 'rdnetto/YCM-Generator', {
                \'branch': 'stable',
                \'for': 'YcmGenerateConfig'
            \}

        " auto-pairs
        Plug 'jiangmiao/auto-pairs'

        " Rainbow_Parentheses
        Plug 'junegunn/rainbow_parentheses.vim', {
                \'on': 'RainbowToggle'
            \}

        " ale
        Plug 'w0rp/ale'

        " Quick-Scope
        Plug 'unblevable/quick-scope'

        " vim-gitgutter
        Plug 'airblade/vim-gitgutter'

        "Plug 'Valloric/YouCompleteMe', {
        "    \'do': './install.py --clang-completer'
        "\}

        " deoplete
        if has('nvim')
          Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        else
          Plug 'Shougo/deoplete.nvim'
          Plug 'roxma/nvim-yarp'
          Plug 'roxma/vim-hug-neovim-rpc'
        endif

        " deoplete-jedi
        Plug 'deoplete-plugins/deoplete-jedi', {
           \'for': 'python'
        \}

        " vim-polyglot
        " Plug 'sheerun/vim-polyglot'
call plug#end()
" }}}
" Plugin Configurations {{{
" NERDTree Settings {{{
" autocmd vimenter * NERDTree     " Open a NERDTree automatically on vim startup
" autocmd StdinReadPre * let s:std_in=1 " open a NERDTree automatically when vim
                                      " starts up if no files were specified
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nmap <C-n> :NERDTreeToggle<CR>  "Open NERDTree with Ctrl+n
let NERDTreeShowHidden=1 " Show hidden files by default
let NERDTreeQuitOnOpen=1 " Close automatically when opening/editing a file
map <Leader>n <plug>NERDTreeTabsToggle<CR> " Open NERDTree with <CTRL+n>
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif "Close vim if the only window left open is a NERDTree
" }}}
" ALE settings {{{
" Quick leader toggle for ALE checking
nnoremap <Leader>ta :ALEToggle<CR>
nnoremap <Leader>an :ALENextWrap<CR>
nnoremap <Leader>ap :ALEPreviousWrap<CR>
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_sign_error = '✖ '
let g:ale_sign_warning = '⚠ '
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
\   'python': ['flake8'],
\}
let g:ale_python_flake8_options = '--ignore=E501'
nnoremap <Leader>ta :ALEToggle<CR>
nnoremap <Leader>an :ALENextWrap<CR>
nnoremap <Leader>ap :ALEPreviousWrap<CR>
" }}}
 "Use ocp-indent to make autotabbing easy
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
filetype plugin on " Turn on omni completion
" set omnifunc=syntaxcomplete#Complete

" Language settings
" Enable all Python syntax highlighting features
let python_highlight_all = 1

" Enable merlin, an interactive OCaml code analysis plugin, to be used with vim
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Airline settings {{{
 let g:airline_theme='onedark'
let g:airline#extensions#ale#enabled = 1
" let g:solarized_base16 = 1
" let g:airline_solarized_normal_green = 1
" let g:airline_solarized_dark_inactive_border = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" }}}
" Vim Session settings {{{
let g:session_autosave = 'no'
set sessionoptions-=options    " Do not save global and local values
set sessionoptions-=folds      " Do not save folds
set sessionoptions-=buffers
set sessionoptions-=blank
" }}}
" Vim Notes settings {{{
let g:notes_directories = ['~/Google Drive/Documents/Notes/Vim Notes'] ", '~/Google Drive/Documents/Notes/Text Notes/CS/Programming Langauges']
let g:notes_tab_indents = 0
let g:notes_conceal_url = 0
" }}}
" YouCompleteMe Settings {{{
let g:loaded_youcompleteme = 1 " Don't load YCM
let g:ycm_python_binary_path = '~/.anaconda3/bin/python'
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_key_list_stop_completion = ['<C-y>', '<Enter>']
" }}}
" Deoplete Settings {{{
let g:deoplete#sources#jedi#show_docstring = 1
" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
autocmd InsertEnter * call deoplete#enable()
let g:deoplete#max_list = 50
" Quick leader toggle for autocompletion
nnoremap <Leader>td :call deoplete#toggle()<CR>  " Doesn't work with enable deoplete when InsertEnter (which re-enables deoplete)
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Close preview window affter completion
" autocmd CompleteDone * silent! pclose!
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}
" Indent Line Settings {{{
let g:indentLine_char = '┆'"
let g:indentLine_color_term = 248
autocmd FileType markdown,tex let g:indentLine_enabled=0
" }}}
" Ultisnips Settings {{{
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
" }}}
" Rainbow_Parentheses Settings {{{
let g:rainbow#max_level = 20
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
let g:rainbow#blacklist = [233, 234, 235, 236]
" au BufEnter * :Rainbow_Parentheses<CR>
" }}}
" FZF settings {{{
let g:fzf_command_prefix = 'F'

" Find files in cwd
nnoremap <C-p> :FZF<CR>A

" Find lines in open buffers (note <C-/> is mapped to <C-_>)
nnoremap <C-_> :FLines<CR>

" Buffers
nnoremap <leader>b :FBuffers<CR>

" Tabs
nnoremap <leader>t :FWindows<CR>

" Marks
nnoremap <leader>m :FMarks<CR>

" History
nnoremap <leader>h :FHistory<CR>
nnoremap q: :FHistory:<CR>
nnoremap q/ :FHistory/<CR>
" }}}
" vim-gitgutter settings {{{
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
" }}}
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
" Function to permanently delete views created by 'mkview' {{{
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    " vim's odd =~ escaping for /
    let path = substitute(path, '=', '==', 'g')
    if empty($HOME)
    else
        let path = substitute(path, '^'.$HOME, '\~', '')
    endif
    let path = substitute(path, '/', '=+', 'g') . '='
    " view directory
    let path = &viewdir.'/'.path
    call delete(path)
    echo "Deleted: ".path
endfunction

" # Command Delview (and it's abbreviation 'delview')
command Delview call MyDeleteView()
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>
" }}}
