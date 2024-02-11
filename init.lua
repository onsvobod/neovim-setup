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
