-------------------------------------------------------------------------------
------------------------------- General config --------------------------------
-------------------------------------------------------------------------------

local g = vim.g
local opt = vim.opt
local vim = vim

opt.mouse = 'a'                                 -- Enable mouse support
opt.encoding = 'utf-8'                          -- Encoding
opt.clipboard = 'unnamedplus'                   -- Use system clipboard for copy/paste
opt.swapfile = false                            -- Don't use swapfile
opt.completeopt = 'noinsert,menuone,noselect'   -- Options for autocomplete
opt.backspace = 'indent,eol,start'              -- Allow backspacing in insert mode

-------------------------------------------------------------------------------
---------------------------------- Plugins ------------------------------------
-------------------------------------------------------------------------------

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('Tworg/gruvbox')   -- Colorscheme
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- Smart indentation, highlight, folding...

vim.call('plug#end')

-------------------------------------------------------------------------------
------------------------------------ GUI --------------------------------------
-------------------------------------------------------------------------------

opt.number = true               -- Line numbers
opt.ruler = true                -- Show line adn column number on cursor position
opt.termguicolors = true        -- 24-bit colors
opt.showmatch = true            -- Show matching parenthesis
opt.hlsearch = true             -- Highligh matches in search
opt.ignorecase = true           -- Ignore case of letters during search
opt.smartcase = true            -- Ignore case of letters in patterns with only lowercase letters
opt.splitbelow = true           -- Move horizontal split to the bottom
opt.splitright = true           -- Move vertical split to the right
vim.cmd('colorscheme gruvbox')  -- Choose colorscheme

-------------------------------------------------------------------------------
-------------------------------- Indentation ----------------------------------
-------------------------------------------------------------------------------

opt.tabstop = 4             -- one tab is 4 spaces
opt.shiftwidth = 4          -- 4 spaces when tab
opt.smartindent = true      -- New line autoindent
opt.expandtab = true        -- Spaces instead of tabs
opt.list = true             -- Make whitespaces visible
opt.listchars = 'tab:>-'    -- Set chars to make tabs visible
g.indentLine_char = '|'     -- Show indent line (exclude nerd tree)
g.indentLine_bufNameExclude = { 'NERD_tree.*' }

-------------------------------------------------------------------------------
---------------------------------- Folding ------------------------------------
-------------------------------------------------------------------------------

opt.foldmethod = 'expr'                     -- Use treesitter for folding
opt.foldexpr= 'nvim_treesitter#foldexpr()'
opt.foldenable = false                      -- Dont fold by default

-------------------------------------------------------------------------------
------------------------ Filetype specific settings ---------------------------
-------------------------------------------------------------------------------

local setColorColumn = function(filetype)
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        pattern = filetype,
        callback = function()
            vim.opt_local.colorcolumn = '120'
        end
    })
end

local setTabWidth2 = function(filetype)
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        pattern = filetype,
        callback = function()
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
        end
    })
end

local useTabs = function(filetype)
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        pattern = filetype,
        callback = function()
            vim.opt.expandtab = false
            vim.opt.list = false
        end
    })
end

setColorColumn('*.py')
setColorColumn('*.c')
setColorColumn('*.cc')
setColorColumn('*.cpp')
setColorColumn('*.h')
setColorColumn('*.js')
setColorColumn('*.go')
useTabs('*.go')
setTabWidth2('*.yaml')
setTabWidth2('*.yml')
setTabWidth2('*.json')

-------------------------------------------------------------------------------
--------------------------------- Keybinds ------------------------------------
-------------------------------------------------------------------------------

local map = vim.keymap.set

g.mapleader = ','                                                           -- Set <leader>
map('i', '<c-c>', '<ESC>')                                                  -- Ctrl-c -> Esc
map('', '<c-t>h', ':tabp<Enter>')                                           -- Ctrl-t + h -> move tab left
map('', '<c-t>l', ':tabn<Enter>')                                           -- Ctrl-t + l -> move tab right
map('t', '<Esc>', "<C-\\><C-n>")                                            -- Esc -> escape :terminal
map('n', '<C-k>', ':call LanguageClient#textDocument_definition()<Enter>')  -- Ctrl-k -> GoTo definition
map('n', '<C-l>', ':call LanguageClient#textDocument_references()<Enter>')  -- Ctrl-l -> GoTo reference
map('n', '<F7>', ':AsyncRun -program=make<Enter>')                          -- F7 -> Run makeprg
map('', '<C-n>', ':NERDTreeToggle<CR>')                                     -- Ctrl-n -> Open NerdTree
map('n', '<c-G>', ':Grepper -tool grep -cword -noprompt<Enter>')            -- Ctrl-g -> Run Grepper on word under cursor
map('n', '<F8>', ':GdbStart gdb -q<Enter>')                                 -- F8 -> Start gdb
-- Enter -> Select completion
map('i', '<Enter>', 'pumvisible() ? "\\<c-y>\\<cr>" : "\\<CR>"', {expr = true})
-- Tab -> Next completion
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
-- Shift-Tab -> Previous completion
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
