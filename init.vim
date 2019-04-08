"--------general setup-------"
set exrc
set secure
set number
set backspace=indent,eol,start
set encoding=utf-8
set smartcase
inoremap <c-c> <ESC>
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
Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'skywind3000/asyncrun.vim'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
call plug#end()

"--LanguageClient-neovim-"
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'python' : ['pyls'],
  \ }
nnoremap <C-k> :call LanguageClient#textDocument_definition()<CR>

"-----------ncm2---------"
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-6.0/lib'
set shortmess+=c
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"-----------nerdtree---------"
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__', '__pycache__']
map <C-n> :NERDTreeToggle<CR>

"---------Async---------"
:noremap <F7> :AsyncRun -program=make<cr>
let g:asyncrun_open = 10
