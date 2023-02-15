"--------general setup-------"
set exrc
set secure
set number
set backspace=indent,eol,start
set encoding=utf-8
set ignorecase
set smartcase
let mapleader=","
set mouse=a
inoremap <c-c> <ESC>
command Ninja ninja
map <c-t>h :tabp<CR>
map <c-t>l :tabn<CR>

"--------syntax setup--------"
syntax on
set hlsearch
set ruler
filetype plugin indent on
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
colorscheme torte
set background=dark
hi Normal ctermbg=none
highlight NonText ctermbg=none
autocmd BufRead,BufNewFile *.py setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.cc setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.cpp setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.c setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.h setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.js setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.go setlocal colorcolumn=120
highlight ColorColumn ctermbg=darkgrey guifg=darkgrey
highlight LineNr ctermbg=black
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType go setlocal noet ts=4 sw=4 sts=4

set list
set listchars=tab:>-
autocmd FileType go set nolist

tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <Esc>
tnoremap <C-v><Esc> <Esc>

"---parenthesis completion---"
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

"------function folding------"
set foldmethod=indent
set foldlevel=0
set foldnestmax=1

"-----new tab change cwd------"
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction()
autocmd TabNew * call OnTabEnter(expand("<amatch>"))

"-----------plugins----------"
call plug#begin('~/.local/share/nvim/plugged')
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'skywind3000/asyncrun.vim'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'vim-scripts/a.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'chrisbra/csv.vim'
Plug 'cdelledonne/vim-cmake'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'gcmt/taboo.vim'
call plug#end()

"--LanguageClient-neovim-"
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'python' : ['pyls'],
  \ 'javascript' : ['javascript-typescript-stdio'],
  \ 'go': ['gopls'],
  \ }
nnoremap <C-k> :call LanguageClient#textDocument_definition()<CR>
nnoremap <C-l> :call LanguageClient#textDocument_references()<CR>
let g:LanguageClient_autoStart = 1
" Run gofmt on save
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

"-----------ncm2---------"
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-13/lib'
set shortmess+=c
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"-----------nerdtree---------"
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__', '__pycache__']
map <C-n> :NERDTreeToggle<CR>
" make new tab new cwd work
let g:NERDTreeHijackNetrw = 0

"---------Async---------"
:noremap <F7> :AsyncRun -program=make<cr>
let g:asyncrun_open = 10


"----------fzf----------"
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~30%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

"--------grepper--------"
let g:grepper = {}
let g:grepper.tools = ['grep']
let g:grepper.quickfix = 0
let g:grepper.highlight = 1
runtime plugin/grepper.vim
let g:grepper.grep.grepprg .= ' -is --exclude-dir=out_linux'
nnoremap <c-G> :Grepper -tool grep -cword -noprompt<cr>

"----------csv----------"
let b:csv_arrange_align='l*'
aug CSV_Editing
    au!
    au BufRead,BufWritePost *.csv :%ArrangeColumn
    au BufWritePre *.csv :%UnArrangeColumn
aug end
let g:csv_delim_test = ',;|'

"----------gdb----------"
" We're going to define single-letter keymaps, so don't try to define them
" in the terminal window.  The debugger CLI should continue accepting text commands.
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

:noremap <F8> :GdbStart gdb -q

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_breakpoint': 'b',
  \ 'key_eval': 'e',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }


"---------indent---------"
let g:indentLine_bufNameExclude = ['NERD_tree.*']
let g:indentLine_char = '|'
