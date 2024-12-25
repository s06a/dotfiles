" ========================
" Basic Vim Configuration
" ========================
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" Editor Settings
set number                " Show line numbers
set mouse=a               " Enable mouse support
set wrap                  " Wrap long lines
set showcmd               " Show last executed command
set showmatch             " Highlight matching parentheses
set incsearch             " Incremental search
set hlsearch              " Highlight search matches
set ignorecase            " Case-insensitive searching
set smartcase             " Case-sensitive if uppercase is used
set ruler                 " Show cursor position
set wildmenu              " Enhanced command-line completion
set tabstop=2             " Number of spaces for a tab
set shiftwidth=2          " Indentation width
set expandtab             " Use spaces instead of tabs
set autoindent            " Enable automatic indentation
set smartindent           " Smart indentation
set laststatus=2          " Always show status line
set textwidth=80          " Wrap text at 80 characters
set formatoptions=qrn1    " Automatic formatting options
set complete-=i           " Disable scanning included files for completion
set smarttab              " Smart tab behavior
set clipboard=unnamedplus " Use system clipboard
set signcolumn=no         " Disable the Sign Column

" ========================
" Plugin Management
" ========================
call plug#begin('~/.vim/plugged')

" File Explorer
Plug 'preservim/nerdtree'

" Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Google Plugins for Formatting
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" Productivity
Plug 'Raimondi/delimitMate'               " Auto-pairing of brackets
Plug 'preservim/vim-indent-guides'        " Indentation guides
Plug 'ryanoasis/vim-devicons'             " Filetype icons
Plug 'tomasiser/vim-code-dark'            " Theme: Code Dark
Plug 'preservim/nerdcommenter'            " For NERDCommenter

" LSP and Completion
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Go-specific Tools
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" ========================
" UI and Appearance
" ========================
syntax enable             " Enable syntax highlighting
set t_Co=256              " Support 256 colors
colorscheme codedark      " Set theme
set background=dark       " Dark background

" Vim Airline Configuration
let g:airline_theme = 'minimalist'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" NERDTree Configuration
let g:NERDTreeShowHidden=1

" File-type specific overrides
autocmd FileType * setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType make setlocal noexpandtab

" ========================
" Keybindings
" ========================
nnoremap <F1> :NERDTreeToggle<CR> " Toggle NERDTree

" LSP Keybindings
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gr :LspReferences<CR>
nnoremap <silent> gi :LspImplementation<CR>
nnoremap <silent> gt :LspTypeDefinition<CR>
nnoremap <silent> f :LspHover<CR>
nnoremap <silent> <leader>rn :LspRename<CR>
nnoremap <silent> <leader>ca :LspCodeAction<CR>

" Autocomplete Keybindings
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Toggle comments for the current line or selection
function! ToggleComment()
    " Detect the file type
    let filetype = &filetype
    let comment_char = "//" " Default to // for C-like languages
    if filetype == 'python' || filetype == 'sh' || filetype == 'tmux'
        let comment_char = "#"
    elseif filetype == 'vim'
        let comment_char = '"'
    elseif filetype == 'rust' || filetype == 'cpp' || filetype == 'c' || filetype == 'go'
        let comment_char = "//"
    endif

    if mode() ==# 'v'
        " Visual mode: toggle comment for selected lines
        execute "normal! '<"
        let first_line = line("'<")
        let last_line = line("'>")
        for line_num in range(first_line, last_line)
            let line = getline(line_num)
            if line =~ '^\s*' . comment_char . '\s*'
                " Uncomment the line
                call setline(line_num, substitute(line, '^\(\s*\)' . comment_char . '\s*', '\1', ''))
            else
                " Comment the line
                call setline(line_num, substitute(line, '^\(\s*\)', '\1' . comment_char . ' ', ''))
            endif
        endfor
    else
        " Normal mode: toggle comment for the current line
        let line = getline(".")
        if line =~ '^\s*' . comment_char . '\s*'
            " Uncomment the line
            call setline(line("."), substitute(line, '^\(\s*\)' . comment_char . '\s*', '\1', ''))
        else
            " Comment the line
            call setline(line("."), substitute(line, '^\(\s*\)', '\1' . comment_char . ' ', ''))
        endif
    endif
endfunction

" Map Ctrl+/ for toggling comments
nnoremap <C-_> :call ToggleComment()<CR>
vnoremap <C-_> :<C-U>call ToggleComment()<CR>

" ========================
" Autoformat Settings
" ========================
augroup autoformat_settings
  autocmd!
  autocmd FileType go AutoFormatBuffer goimports
  autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType javascript,html,css AutoFormatBuffer prettier
augroup END

" ========================
" Language Server Protocol (LSP)
" ========================
if executable('gopls')
  autocmd FileType go call lsp#register_server({
  \ 'name': 'gopls',
  \ 'cmd': ['gopls'],
  \ 'whitelist': ['go'],
  \ })
endif

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_lsp#enable = 1

" ========================
" Go Testing Keybindings
" ========================
nnoremap <silent> <leader>tt :GoTest<CR>       " Run all tests
nnoremap <silent> <leader>tf :GoTestFunc<CR>  " Run test for the current function
nnoremap <silent> <leader>tc :GoCoverage<CR>  " Show test coverage
