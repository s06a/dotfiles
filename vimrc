" set encoding
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" plugin manager
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'fisadev/FixedTaskList.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'Raimondi/delimitMate'
Plug 'preservim/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'godlygeek/tabular' " :Tabularize /<separator>

call plug#end()

" configs for the theme
syntax enable
colorscheme monokai
set background=dark

" vim configs
set number             " enable numbers
set mouse=a            " enable mouse
set ls=2               " set line spacing for readability
set showcmd            " show latest executed command
set showmatch          " highligh matching pairs (such as brackets)
set incsearch          " search as you type
set hlsearch           " highlight all occurances
set ignorecase         " make searches case-insensitive
set ruler              " show cursor position at the bottom right
set wrap               " wrap long lines
set wildmenu           " enhance the command-line completion menu
set tabstop=4          " number of spaces for a tab
set binary             " no new lines at the of the file
set noeol
set laststatus=2       " show status line
set showmode           " show the current mode
set textwidth=80       " limit text width
set formatoptions=qrn1 " handle text formatting
set autoindent         " better indentations
set smartindent
set complete-=i
set smarttab

" enable autocompletion (use ctrl+n to see options in vim)
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" keybindings
nmap <F1> :NERDTreeToggle<CR>
nmap <F2> :TaskList<CR>

" global configs
let g:airline_theme = 'minimalist'
" let g:indent_guides_enable_on_vim_startup = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:NERDTreeShowHidden=1

let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '| '

" configs for auto formats
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
  autocmd FileType swift AutoFormatBuffer swift-format
augroup END

" TODO
" youcompleteme
