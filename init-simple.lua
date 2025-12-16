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

Plug('Tworg/gruvbox')                                           -- Colorscheme
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- Smart indentation, highlight, folding...
Plug('nvim-lua/plenary.nvim')                                   -- Required by neo-tree
Plug('MunifTanjim/nui.nvim')                                    -- Required by neo-tree
Plug('nvim-neo-tree/neo-tree.nvim', {['branch'] = 'v3.x'})      -- Filesystem browser
Plug('nvim-lualine/lualine.nvim')                               -- Better status line
Plug('lukas-reineke/indent-blankline.nvim')                     -- Show indent line
Plug('windwp/nvim-autopairs')                                   -- Parenthesis completion

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
vim.cmd('colorscheme torte')  -- Choose colorscheme

vim.api.nvim_set_hl(0, 'GruvboxWhiteSign', { ctermfg=223, ctermbg=237, fg="#ebdbb2", bg="#3c3836" })
vim.api.nvim_set_hl(0, 'NormalFloat', { link = "GruvboxWhiteSign" })
vim.api.nvim_set_hl(0, 'DiagnosticError', { link = "GruvboxRedSign" })
vim.api.nvim_set_hl(0, 'diagnosticwarn', { link = "gruvboxyellowsign" })
vim.api.nvim_set_hl(0, 'diagnosticinfo', { link = "gruvboxpurplesign" })
vim.api.nvim_set_hl(0, 'diagnostichint', { link = "gruvboxbluesign" })
vim.api.nvim_set_hl(0, 'diagnosticok', { link = "gruvboxgreensign" })

-------------------------------------------------------------------------------
-------------------------------- Indentation ----------------------------------
-------------------------------------------------------------------------------

opt.tabstop = 4             -- one tab is 4 spaces
opt.shiftwidth = 4          -- 4 spaces when tab
opt.smartindent = true      -- New line autoindent
opt.expandtab = true        -- Spaces instead of tabs
opt.list = true             -- Make whitespaces visible
opt.listchars = 'tab:>-'    -- Set chars to make tabs visible

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
            vim.opt_local.colorcolumn = '81'
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

g.mapleader = ','                                                   -- Set <leader>
map('i', '<c-c>', '<ESC>')                                          -- Ctrl-c -> Esc
map('', '<c-t>h', ':tabp<Enter>')                                   -- Ctrl-t + h -> move tab left
map('', '<c-t>l', ':tabn<Enter>')                                   -- Ctrl-t + l -> move tab right
map('t', '<Esc>', "<C-\\><C-n>")                                    -- Esc -> escape :terminal
map('n', '<F7>', ':AsyncRun -program=make<Enter>')                  -- F7 -> Run makeprg
map('n', '<F8>', ':GdbStart gdb -q<Enter>')                         -- F8 -> Start gdb

-------------------------------------------------------------------------------
---------------------------------- Neotree ------------------------------------
-------------------------------------------------------------------------------

-- Ctrl-m -> Open fullscreen NeoTree
map('', '<C-n>', ':Neotree toggle position=float<CR>')
require('neo-tree').setup({
    window = {
        width = 32,
    }
})

-------------------------------------------------------------------------------
---------------------------------- LuaLine ------------------------------------
-------------------------------------------------------------------------------

require('lualine').setup({
    sections = {
        lualine_c = {
            {
                'filename', path = 1, newfile_status = true
            }
        },
    },
    inactive_sections = {
        lualine_c = {
            {
                'filename', path = 1, newfile_status = true
            }
        },
    },
    extensions = {'neo-tree'},
    options = {
        theme = 'gruvbox'
    }
})
