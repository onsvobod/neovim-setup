"--------general setup-------"
set exrc
set secure
set number
set backspace=indent,eol,start
set encoding=utf-8
set smartcase
command Ninja ninja

"--------syntax setup--------"
syntax on
set hlsearch
set ruler
filetype plugin indent on
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
colorscheme desert
set background=dark
hi Normal ctermbg=none
highlight NonText ctermbg=none
autocmd BufRead,BufNewFile *.py setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.cc setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.cpp setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.c setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.h setlocal colorcolumn=80
autocmd BufRead,BufNewFile *.js setlocal colorcolumn=80
highlight ColorColumn ctermbg=darkgrey guifg=darkgrey
highlight LineNr ctermbg=black

set list
set listchars=tab:>-

"---parenthesis completion---"
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

"------function folding------"
set foldmethod=indent
set foldlevel=0
set foldnestmax=1

"-----------plugins----------"
call plug#begin('~/.local/share/nvim/plugged')
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'skywind3000/asyncrun.vim'
call plug#end()

let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'python' : ['pyls'],
  \ }

"-----------deoplete---------"
"selection in dropdown using j and k keys
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
"enable at startup"
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path="/usr/lib/llvm-7/lib/libclang.so.1"
let g:deoplete#sources#clang#clang_header="/usr/lib/llvm-7/lib/clang/7.0.1/include"

"-----------nerdtree---------"
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__', '__pycache__']
map <C-n> :NERDTreeToggle<CR>

"---------Async---------"
:noremap <F7> :AsyncRun -program=make<cr>
let g:asyncrun_open = 10
