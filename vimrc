" plugin manager
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'fisadev/FixedTaskList.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'sentientmachine/Pretty-Vim-Python'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'Raimondi/delimitMate'
Plug 'preservim/vim-indent-guides'

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

" keybindings
nmap <F1> :NERDTreeToggle<CR>
nmap <F2> :TaskList<CR>

let g:airline_theme = 'minimalist'

let g:indent_guides_enable_on_vim_startup = 1
