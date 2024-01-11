" plugin manager
call plug#begin()

Plug 'arzg/vim-colors-xcode'
Plug 'preservim/nerdtree'
Plug 'fisadev/FixedTaskList.vim'

call plug#end()

" configs for the theme
syntax enable
colorscheme monokai

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
