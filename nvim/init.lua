--[[
  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- [[[ Configrue COQ ]]
vim.g.coq_settings = {
    display = { icons = { mode = 'none' }, pum = { fast_close = false } },
    -- auto_start = 'shut-up',
    auto_start = 'shut-up',
}

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    -- NOTE: First, some plugins that don't require any configuration
    -- Legacy plugins from init.vim
    'SirVer/ultisnips',
    'junegunn/fzf',
    'junegunn/fzf.vim',
    'sainnhe/gruvbox-material',

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },
    },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    {
        'ms-jpq/coq_nvim',
        branch = 'coq'
    },
    { 'ms-jpq/coq.artifacts',  branch = 'artifacts' },
    { 'ms-jpq/coq.thirdparty', branch = '3p' },
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}, {})

vim.cmd [[colorscheme gruvbox-material]]
vim.cmd [[
let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-p']
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   <q-args>, $AG_DEFAULT_OPTIONS,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
]]
vim.cmd [[ hi DiagnosticVirtualTextWarn guifg=Gray ctermfg=Gray ]]

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false
vim.o.cmdheight = 2
vim.opt.colorcolumn = "80"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.expandtab = true
vim.o.exrc = true
vim.o.hidden = true
vim.o.incsearch = true
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.splitright = true
vim.o.timeoutlen=180
vim.o.updatetime=50
vim.o.conceallevel=0
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.cmd [[
" Disable the mouse input
set mouse=

set cmdheight=2
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set expandtab
set exrc
set guicursor=
set hidden
set incsearch
set nobackup
set noerrorbells
set nohlsearch
set noshowmode
set noswapfile
set nowrap
set number
set relativenumber
set shiftwidth=4
set shortmess+=c
set signcolumn=yes
set smartindent
set splitright
set tabstop=4 softtabstop=4
set termguicolors
set timeoutlen=180
set undodir=~/.vim/undodir
set undofile
set updatetime=50
set smartcase
set pumblend=40
hi PmenuSel blend=0
hi PmenuSbar guifg=#11f0c3 guibg=#ff00ff

set t_ut=
set autoread

hi DiagnosticVirtualTextWarn guifg=Gray ctermfg=Gray
]]


vim.cmd [[
inoremap ! !<c-g>u
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap ? ?<c-g>u
map <c-_> <Plug>NERDCommenterToggle
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Leader>N :cprevious<CR>
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>w :wa<CR>
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <leader>F :Files<cr>
nnoremap <leader>I :e ~/.ignore<CR>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>c f{a<cr><esc>O
nnoremap <leader>E :Ex<CR>
nnoremap <leader>f :Ag<cr>
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap <leader>i :e ~/.config/nvim/init.lua<CR>
nnoremap <leader>j :call TrimWhitespace()<CR>
nnoremap <leader>l yiw:Lines <c-r>"<cr>
nnoremap <leader>o :G blame<CR>
nnoremap <leader>t yiw:Ag <c-r>"<cr>
nnoremap <silent><leader>0 :exec '!echo "cb" \| nc localhost 65432'<CR>
nnoremap <silent><leader>7 :exec '!echo "tt" \| nc localhost 65432'<CR>
nnoremap <silent><leader>8 :exec '!echo "bb" \| nc localhost 65432'<CR>
nnoremap <silent><leader>9 :exec '!echo "uu" \| nc localhost 65432'<CR>
nnoremap <silent>y<Leader>f :let @* = expand("%")<CR>
nnoremap dl dt)
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
noremap <Leader>s :UltiSnipsEdit<CR>
tnoremap <Esc> <C-\><C-n>
vnoremap <leader>k "ky :!echo "<c-R>k" \| nc localhost 10004<CR>
vnoremap <leader>t y:Ag <c-r>"<cr>
vnoremap <silent> <c-u> <esc>:Gdiff<cr>gv:diffget<cr><c-w><c-w>ZZ
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" running files
autocmd FileType cpp             nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Ag++ <C-\><C-n>"vpA -o a.out && ./a.out<CR>
autocmd FileType python          nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Apython <C-\><C-n>"vpA<CR>
autocmd FileType markdown        nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Aglow <C-\><C-n>"vpA<CR>
autocmd FileType c               nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Abu<CR>
]]



-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,noinsert'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- See https://github.com/ms-jpq/coq_nvim/issues/403
require("coq")

-- [[ Configure Lualine ]]
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                newfile_status = false, -- Display new file status (new file means no write after created)
                path = 4,               -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path
                -- 3: Absolute path, with tilde as the home directory
                -- 4: Filename and parent dir, with tilde as the home directory

                shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = '[+]',      -- Text to show when the file is modified.
                    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[No Name]', -- Text to show for unnamed buffers.
                    newfile = '[New]',     -- Text to show for newly created file before first write
                }
            }
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
vim.lsp.set_log_level("off")
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
    })
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local clangd_flags = {
    "--background-index",
    "--cross-file-rename",
    "--clang-tidy",
    "--header-insertion=never",
    "--compile-commands-dir=/home/kkelso/projects/9305/kevyn",
    --"--limit-references=500",
    --"--limit-results=50",
    --"--project-root=/home/kkelso/projects/9305",
    --"--remote-index-address=''",
    "--all-scopes-completion",
}

local servers = {
    clangd = { cmd = { "clangd", unpack(clangd_flags) } },
    -- gopls = {},
    pyright = {},
    -- rust_analyzer = {},
    tsserver = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
