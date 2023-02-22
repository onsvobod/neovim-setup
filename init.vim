"-----------plugins----------"
call plug#begin('~/.local/share/nvim/plugged')
" Colors
Plug 'Tworg/gruvbox'
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" File explorer
Plug 'scrooloose/nerdTree'
" Status line
Plug 'bling/vim-airline'
" Tabs
Plug 'gcmt/taboo.vim'
" Indent line
Plug 'lukas-reineke/indent-blankline.nvim'
" Parentesis completion
Plug 'jiangmiao/auto-pairs'
" Search
Plug 'mhinz/vim-grepper'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Code check
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
" Completion
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
" Needed by ncm2
Plug 'roxma/nvim-yarp'
" .cc <--> .h
Plug 'vim-scripts/a.vim'
" Build
Plug 'cdelledonne/vim-cmake'
Plug 'skywind3000/asyncrun.vim'
" Debugger
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Git diff
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim', {'branch': 'main'}
call plug#end()

"-----------general----------"
" Cannot use shell commands in autocmd in .vimrc
set secure
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start 
" Encoding
set encoding=utf-8
" Ignore case of letters
set ignorecase
" Ignore case of letters in patterns with only lowercase letters
set smartcase
" Enable mouse support in all modes
set mouse=a
" Detects filetype
filetype plugin indent on
" Tab setup - use 4 spaces
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

"-----------visual-----------"
" Select gruvbox as colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
" Show linenumbers
set number
" Show line and column number on cursor position
set ruler
" Highlight matches in search
set hlsearch
" 24bit color
set termguicolors
" Folding - using treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable 
" Show indentline
let g:indentLine_bufNameExclude = ['NERD_tree.*']
let g:indentLine_char = '|'
" Hightlight tabs
set list
set listchars=tab:>-

"-----------filetype-----------"
" Python
autocmd BufRead,BufNewFile *.py setlocal colorcolumn=120
" C/C++
autocmd BufRead,BufNewFile *.cc setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.cpp setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.c setlocal colorcolumn=120
autocmd BufRead,BufNewFile *.h setlocal colorcolumn=120
" Javascritp
autocmd BufRead,BufNewFile *.js setlocal colorcolumn=120
" Golang - use tabs instead of spaces
autocmd BufRead,BufNewFile *.go setlocal colorcolumn=120
autocmd FileType go setlocal softtabstop=4 noexpandtab
autocmd FileType go set nolist
" Yaml
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2

"-----------keybinds-----------"
" Set <leader>
let mapleader=","
" Ctrl-c -> Esc
inoremap <c-c> <ESC>
" Ctrl-t + h -> move tab left
map <c-t>h :tabp<Enter>
" Ctrl-t + l -> move tab right
map <c-t>l :tabn<Enter>
" Esc -> escape :terminal
tnoremap <Esc> <C-\><C-n>
" Ctrl-k -> GoTo definition
nnoremap <C-k> :call LanguageClient#textDocument_definition()<Enter>
" Ctrl-l -> GoTo reference
nnoremap <C-l> :call LanguageClient#textDocument_references()<Enter>
" Enter -> Select completion
inoremap <expr> <Enter> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Tab -> Next completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Shift-Tab -> Previous completion
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Ctrl-n -> Open NerdTree
map <C-n> :NERDTreeToggle<CR>
" F7 -> Run makeprg
noremap <F7> :AsyncRun -program=make<Enter>
" Run Grepper on word under cursor
nnoremap <c-G> :Grepper -tool grep -cword -noprompt<Enter>
" Start gdb
noremap <F8> :GdbStart gdb -q<Enter>

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

"-----------treesitter----------"
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  -- Does not compile
  ignore_install = { "smali" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    -- Dont use together with :syntax on
    additional_vim_regex_highlighting = false,
  },
  --indent = {
  --  enable = true
  --},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Enter>",
      node_incremental = "<Enter>",
      scope_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
  },
}
EOF

"--LanguageClient-neovim-"
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ 'python' : ['pyls'],
  \ 'javascript' : ['javascript-typescript-stdio'],
  \ 'go': ['gopls'],
  \ }
let g:LanguageClient_autoStart = 1

"-----------ncm2---------"
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-13/lib'
set shortmess+=c

"-----------nerdtree---------"
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__', '__pycache__']
" make new tab new cwd work
let g:NERDTreeHijackNetrw = 0

"---------Async---------"
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

"----------gdb----------"
" We're going to define single-letter keymaps, so don't try to define them
" in the terminal window.  The debugger CLI should continue accepting text commands.
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction
let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_breakpoint': 'b',
  \ 'key_eval': 'e',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }
