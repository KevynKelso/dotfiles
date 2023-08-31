set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

call plug#begin()
  Plug 'SirVer/ultisnips'
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-gitgutter'
  " Plug 'sainnhe/sonokai'
  " Plug 'vim-airline/vim-airline'
  " Plug 'vim-airline/vim-airline-themes'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'sainnhe/gruvbox-material'

if has("nvim")
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'ellisonleao/gruvbox.nvim'
endif
call plug#end()

" let g:sonokai_style = 'shusia'
" let g:sonokai_better_performance = 1
"let g:airline_theme = 'distinguished'
"let g:airline#extensions#tabline#enabled = 1
" let g:airline_highlighting_cache = 1
"let g:airline_powerline_fonts = 0
"let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
"let g:airline_skip_empty_sections = 1

let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.6, 'yoffset': 1.0 } }

set background=dark
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_dim_inactive_windows = 1
let g:gruvbox_material_transparent_background = 2

colorscheme gruvbox-material
let g:lightline = {'colorscheme' : 'gruvbox_material'}

let mapleader = " "
let maplocalleader = " "

let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:coq_settings = { 'auto_start': 'shut-up' }

let $FZF_DEFAULT_OPTS = '--reverse'

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg-ripgrep --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Autocommands --------------------------------------------------------------
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

autocmd BufEnter *.{html,vim,javascript,typescript,typescriptreact,json,ts,js,tsx,cpp,c,h} setlocal shiftwidth=2 tabstop=2 softtabstop=2
" autocmd BufWritePre * :call TrimWhitespace()
augroup KEVYN
  autocmd!
  " default is 4
  autocmd BufEnter *.{html,vim,javascript,typescript,typescriptreact,json,ts,tsx,cpp} setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd BufEnter *.go setlocal shiftwidth=8 tabstop=8 softtabstop=8
  autocmd BufWritePost *.vim :exec 'so %'
  autocmd BufWritePost *{.c,.h} silent! :exec '!echo "bu" > ~/projects/Extra_Scripts/data/bu-message.txt'
augroup END

" Sets -----------------------------------------------------------------------
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
set nu
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
set conceallevel=0

set t_ut=
set autoread

hi DiagnosticVirtualTextWarn guifg=Gray ctermfg=Gray
" Mappings -------------------------------------------------------------------
" fzf
nnoremap <leader>F :Files<cr>
nnoremap <leader>f :Rg<cr>
nnoremap <leader>t yiw:Rg <c-r>"<cr>
vnoremap <leader>t y:Rg <c-r>"<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>l yiw:Lines <c-r>"<cr>
" jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
" undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
" moving text
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Leader>N :cprevious<CR>
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>w :wa<CR>
nnoremap <silent>y<Leader>f :let @* = expand("%")<CR>
nnoremap dl dt)
nnoremap <leader>j :call TrimWhitespace()<CR>
noremap <Leader>s :UltiSnipsEdit<CR>
tnoremap <Esc> <C-\><C-n>
vnoremap <leader>k "ky :!echo "<c-R>k" \| nc localhost 10004<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
 "vim fugitive
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
" quick edit files
nnoremap <leader>i :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>I :e ~/.ignore<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" python
nnoremap <leader>7 :!echo "t" > ~/projects/Extra_Scripts/data/bu-message.txt<CR>
nnoremap <leader>8 :!echo "b" > ~/projects/Extra_Scripts/data/bu-message.txt<CR>
nnoremap <leader>0 :!echo "cb" > ~/projects/Extra_Scripts/data/bu-message.txt<CR>
nnoremap <leader>9 :!echo "u" > ~/projects/Extra_Scripts/data/bu-message.txt<CR>
map <c-_> <Plug>NERDCommenterToggle

nnoremap <leader>c f{a<cr><esc>O

" running files
autocmd FileType cpp             nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Ag++ <C-\><C-n>"vpA -o a.out && ./a.out<CR>
autocmd FileType python          nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Apython3 <C-\><C-n>"vpA<CR>
autocmd FileType markdown        nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Aglow <C-\><C-n>"vpA<CR>
autocmd FileType c               nnoremap <buffer> <Leader>v :let @v=@%<CR>:vsp<CR>:term<CR>Abu<CR>

lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
-- Using this option may slow down your editor, and you may see some duplicate highlights.
-- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- LSP configuration ---------------------------------------------------------
local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  -- Mappings.

  local opts = { noremap = true, silent = false }

  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>k', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  buf_set_keymap('n', '<Leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

end

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

-- vim.lsp.set_log_level("debug")

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
    },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
    })

nvim_lsp.clangd.setup {
  on_attach = on_attach,
  cmd = { "clangd", unpack(clangd_flags) },
  filetypes = { "h", "c", "cpp" }
}
--nvim_lsp.ccls.setup {
--  on_attach = on_attach,
--  filetypes = { "h", "c", "cpp" }
--}

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  settings = {
      pylsp = {
          plugins = {
              memestra = {
                  enabled = true
              },
              black = {
                  enabled = true
              },
              isort = {
                  enabled = true
              },
              pycodestyle = {
                  ignore = {'E501', 'E402'}
              },
          },
          configurationSources = {"black"},
          formatCommand = {"black"}
      }
  },
  filetypes = { "python" }
}

function dump(o)
if type(o) == 'table' then
local s = '{ '
for k,v in pairs(o) do
if type(k) ~= 'number' then k = '"'..k..'"' end
s = s .. '['..k..'] = ' .. dump(v) .. ','
end
return s .. '} '
else
return tostring(o)
end
end

-- nvim_lsp.cmake.setup {
--   on_attach = on_attach,
--   filetypes = { "cmake" }
-- }

EOF
