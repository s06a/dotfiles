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

call plug#end()

" configs for the theme
syntax enable
colorscheme monokai
set background=dark

" vim configs
set number
set mouse=a
set ls=2
set showcmd
set showmatch
set incsearch
set hlsearch
set ignorecase
set showcmd
set ruler
set wrap
set showmatch
set wildmenu

" keybindings
nmap <F1> :NERDTreeToggle<CR>
nmap <F2> :TaskList<CR>

" global configs
let g:airline_theme = 'minimalist'
let g:indent_guides_enable_on_vim_startup = 1
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

" set encoding
"set encoding=UTF-8
set encoding=utf8
