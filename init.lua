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
Plug('neovim/nvim-lspconfig')                                   -- LSP client configurations
Plug('hrsh7th/nvim-cmp')                                        -- Autocompletion
Plug('hrsh7th/cmp-nvim-lsp')                                    -- Use better autocompletion capabilities from LSP, when using nvim-cmp
Plug('hrsh7th/cmp-buffer')                                      -- Buffer source for autocompletion
Plug('hrsh7th/cmp-path')                                        -- Path source for autocompletion
Plug('saadparwaiz1/cmp_luasnip')                                -- Snippet source for nvim-cmp
Plug('L3MON4D3/LuaSnip')                                        -- Snippet engine
Plug('ErichDonGubler/lsp_lines.nvim')                           -- Show diagnostics in better way
Plug('nvim-tree/nvim-web-devicons')                             -- Required by trouble.nvim and neo-tree
Plug('folke/trouble.nvim')                                      -- Diagnostics window
Plug('nvim-lua/plenary.nvim')                                   -- Required by neo-tree
Plug('MunifTanjim/nui.nvim')                                    -- Required by neo-tree
Plug('nvim-neo-tree/neo-tree.nvim', {['branch'] = 'v3.x'})      -- Filesystem browser
Plug('nvim-lualine/lualine.nvim')                               -- Better status line
Plug('lukas-reineke/indent-blankline.nvim')                     -- Show indent line
Plug('windwp/nvim-autopairs')                                   -- Parenthesis completion
Plug('nvim-lua/plenary.nvim')                                   -- Required by telescope
Plug('nvim-telescope/telescope-fzf-native.nvim')                -- Required by telescope
Plug('nvim-telescope/telescope.nvim')                           -- Telescope
Plug('sindrets/diffview.nvim')                                  -- Show diff of file
Plug('mfussenegger/nvim-lint')                                  -- Linting

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
            vim.opt_local.colorcolumn = '80'
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
------------------------------------ LSP --------------------------------------
-------------------------------------------------------------------------------

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')
local servers = {'clangd', 'gopls', 'bashls', 'cmake', 'dockerls', 'jsonls', 'pyright', 'yamlls'}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        -- nvim-cmp capabilities
        capabilities = capabilities,
    }
end

-- Disable syntax highlight from lsp. This is Treesitters job
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

map('n', 'sf', vim.diagnostic.open_float)                   -- Open diagnostics float window
map('n', 'st', function() require("trouble").toggle() end)  -- Toggle diagnostics Trouble window

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'sc', vim.lsp.buf.declaration, opts)           -- GoTo Declaration
    map('n', 'sd', vim.lsp.buf.definition, opts)            -- GoTo Definition
    map('n', 'si', vim.lsp.buf.implementation, opts)        -- GoTo Implenentation
    map('n', 'sh', vim.lsp.buf.hover, opts)                 -- Show Info about symbol
    map('n', 'sn', vim.lsp.buf.rename, opts)                -- Rename all references to symbol
    map('n', 'sr', vim.lsp.buf.references, opts)            -- Show all references to symbol
  end,
})

require("lsp_lines").setup()

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

-------------------------------------------------------------------------------
---------------------------------- Linting ------------------------------------
-------------------------------------------------------------------------------

require('lint').linters_by_ft = {
    python = {'pylint',}
}

-- Trigger lint after leaving insert mode
vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-------------------------------------------------------------------------------
------------------------------- Autocomplete ----------------------------------
-------------------------------------------------------------------------------
local cmp = require 'cmp'
-- Snippets setup
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { -- Select item from suggestions
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback) -- Use Tab to move down
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback) -- Use Shift-Tab to move up
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

-------------------------------------------------------------------------------
---------------------------------- Neotree ------------------------------------
-------------------------------------------------------------------------------

map('', '<C-n>', ':Neotree toggle<CR>')    -- Ctrl-n -> Open NeoTree
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
        lualine_z = {}
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

-------------------------------------------------------------------------------
------------------------------------ IBL --------------------------------------
-------------------------------------------------------------------------------

require('ibl').setup({
    scope = {
        enabled = false,
    }
})


-------------------------------------------------------------------------------
--------------------------------- AutoPair ------------------------------------
-------------------------------------------------------------------------------

require('nvim-autopairs').setup {}

-------------------------------------------------------------------------------
--------------------------------- Telescope -----------------------------------
-------------------------------------------------------------------------------

map('n', 'tf', require('telescope.builtin').find_files, {})
map('n', 'tg', require('telescope.builtin').live_grep, {})
map('n', 'tw', ':Telescope workspaces<CR>')

require('telescope').setup{
    extensions = {
    },
    pickers = {
        find_files = {
            find_command = {
                'fdfind',
                '--type', 'f',
                '--color=never',
                '--hidden',
                '--follow',
                '-E', '.git/*'
            },
        },
    }
}

-------------------------------------------------------------------------------
-------------------------------- Treesitter -----------------------------------
-------------------------------------------------------------------------------

require('nvim-treesitter.configs').setup {
    ensure_installed = {'asm', 'bash', 'c', 'cmake', 'cpp', 'css', 'csv',
                        'cuda', 'dockerfile', 'doxygen', 'gn', 'go', 'gomod',
                        'gosum', 'haskell', 'html', 'http', 'javascript',
                        'json', 'llvm', 'lua', 'make', 'markdown', 'ninja',
                        'proto', 'python', 'scss', 'sql', 'ssh_config', 'tsv',
                        'typescript', 'vim', 'vimdoc', 'xml', 'yaml'},
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
