-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.mapleader = ' '

-------------------- PLUGINS -------------------------------
require 'paq' {
	{'savq/paq-nvim', opt = true},
  {'neovim/nvim-lspconfig'},
  {'williamboman/nvim-lsp-installer'},
  {'ms-jpq/coq_nvim', branch = 'coq'},
  {'ms-jpq/coq.artifacts', branch = 'artifacts'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope.nvim'},
  {'kyazdani42/nvim-web-devicons'}, -- Icons
  {'folke/tokyonight.nvim'}, -- Color scheme
  {'hoob3rt/lualine.nvim'}, -- Status line
  {'ms-jpq/chadtree', {branch = 'chad', run = 'python3 -m chadtree deps'}}, -- File explorer
  {'s1n7ax/nvim-terminal'},
  {'airblade/vim-rooter'},
  {'goolord/alpha-nvim'},
  {'smiteshp/nvim-gps'},
}

-------------------- PLUGIN SETUP --------------------------
-- Tokyonight
vim.g.tokyonight_style = "night"
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
-- ChadTree
map('n', '<leader>v', '<cmd>CHADopen<cr>')
map('n', '<leader>l', '<cmd>call setqflist([])<cr>')
-- nvim-terminal
require('nvim-terminal').setup()
-- coq
vim.cmd[[let g:coq_settings = { 'auto_start': 'shut-up' }]]
-- alpha
require'alpha'.setup(require'alpha.themes.startify'.opts)
-- nvim-gps
require("nvim-gps").setup({
	icons = {
		["class-name"] = ' ',      -- Classes and class-like objects
		["function-name"] = ' ',   -- Functions
		["method-name"] = ' '      -- Methods (functions inside class-like objects)
	},
	separator = ' > ',
})
local gps = require("nvim-gps")
-- Lualine
require('lualine').setup({
  options = { theme = 'tokyonight' },
  sections = {
    lualine_c = {'filename', { gps.get_location, condition = gps.is_available }},
    lualine_x = {'encoding', 'filetype'}
  },
})

-- Neovide --
vim.cmd[[let neovide_remember_window_size = v:true]]
vim.cmd[[let g:neovide_refresh_rate=60]]
vim.cmd[[set guifont=Hack\ NF:h18]]

-------------------- OPTIONS -------------------------------
vim.cmd[[set path +=**]]	    -- Allows :find to be recursive
local indent, width = 2, 80
opt.colorcolumn = tostring(width)   -- Line length marker
opt.clipboard = "unnamedplus"
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options
opt.cursorline = true               -- Highlight cursor line
opt.expandtab = true                -- Use spaces instead of tabs
opt.formatoptions = 'crqnj'         -- Automatic formatting options
opt.ignorecase = true               -- Ignore case
opt.inccommand = "split"            -- Disable substitution preview
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.pastetoggle = '<F2>'            -- Paste mode
opt.pumheight = 12                  -- Max height of popup menu
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = indent             -- Size of an indent
opt.shortmess = 'atToOFc'           -- Prompt message options
opt.sidescrolloff = 8               -- Columns of context
opt.signcolumn = 'yes'              -- Show sign column
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = indent                -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.textwidth = width               -- Maximum width of text
opt.updatetime = 100                -- Delay before swap file is saved
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
opt.hidden = true                   -- Enable background buffers
opt.backspace = {"indent", "eol", "start"}
opt.incsearch = true                -- Shows the match while typing
opt.hlsearch = true                 -- Highlight found searches
opt.joinspaces = false              -- No double spaces with join
opt.linebreak = true                -- Stop words being broken on wrap
opt.numberwidth = 3                 -- Make the gutter wider by default
opt.swapfile = false                -- Disable swap file
vim.cmd[[colorscheme tokyonight]]

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', 'jk', '<ESC>')
map('n', '<C-w>T', '<cmd>tabclose<CR>')
map('n', '<C-w>m', '<cmd>lua toggle_zoom()<CR>')
map('n', '<C-w>t', '<cmd>tabnew<CR>')
map('n', '<F3>', ':lua toggle_wrap()<CR>')
map('n', '<F4>', ':set scrollbind!<CR>')
map('n', '<F5>', ':checktime<CR>')
map('n', '<S-Down>', '<C-w>2<')
map('n', '<S-Left>', '<C-w>2-')
map('n', '<S-Right>', '<C-w>2+')
map('n', '<S-Up>', '<C-w>2>')
map('n', '<leader>s', ':%s//gcI<Left><Left><Left><Left>')
map('n', '<leader>t', '<cmd>terminal<CR>')
map('n', '<leader>u', '<cmd>update<CR>')
map('n', '<leader>x', '<cmd>conf qa<CR>')
map('n', 'Q', '<cmd>lua warn_caps()<CR>')
map('n', 'U', '<cmd>lua warn_caps()<CR>')
map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
map('t', 'jj', '<ESC>', {noremap = false})
map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-------------------- LSP -----------------------------------
local lsp_installer_servers = require'nvim-lsp-installer.servers'
local ok, rust_analyzer = lsp_installer_servers.get_server("rust_analyzer")
if ok then
    if not rust_analyzer:is_installed() then
        rust_analyzer:install()
    end
end
local ok, omnisharp = lsp_installer_servers.get_server("omnisharp")
if ok then
    if not omnisharp:is_installed() then
        omnisharp:install()
    end
end
local ok, clangd = lsp_installer_servers.get_server("clangd")
if ok then
    if not clangd:is_installed() then
        clangd:install()
    end
end
-- clangd is not installed in windows
require'lspconfig'.clangd.setup{}

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end
    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

-- LSP Prevents inline buffer annotations
vim.lsp.diagnostic.show_line_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>D', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>H', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- TREE-SITTER ---------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'bash', 'c', 'cpp', 'c_sharp', 'comment', 'lua', 'rust', 'toml', 'zig'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-------------------- COMMANDS ------------------------------
function init_term()
  cmd 'setlocal nonumber norelativenumber'
  cmd 'setlocal nospell'
  cmd 'setlocal signcolumn=auto'
end

function toggle_wrap()
  wo.breakindent = not wo.breakindent
  wo.linebreak = not wo.linebreak
  wo.wrap = not wo.wrap
end

function toggle_zoom()
  if zoomed then
    cmd 'wincmd ='
    zoomed = false
  else
    cmd 'resize | vertical resize'
    zoomed = true
  end
end

function warn_caps()
  cmd 'echohl WarningMsg'
  cmd 'echo "Caps Lock may be on"'
  cmd 'echohl None'
end

vim.tbl_map(function(c) cmd(fmt('autocmd %s', c)) end, {
  'TermOpen * lua init_term()',
  'TextYankPost * lua vim.highlight.on_yank {timeout = 200, on_visual = false}',
  'TextYankPost * if v:event.operator is "y" && v:event.regname is "+" | OSCYankReg + | endif',
})


-------------------- TELESCOPE ---------------------------
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    layout_config = {
      horizontal = { width = 0.99, height = 0.99 },
      vertical = { width = 0.99, height = 0.99 },
    },
    winblend = 20, -- Transparency
    sorting_strategy = "descending", -- Where first selection should be located
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-w>"] = "delete_buffer", -- Delete input
        },
        n = {
          ["<C-w>"] = "delete_buffer", -- Delete input
        },
      },
    },
    -- Type :line to go to line
    find_files = {
      on_input_filter_cb = function(prompt)
        local find_colon = string.find(prompt, ":")
        if find_colon then
          local ret = string.sub(prompt, 1, find_colon - 1)
          vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local lnum = tonumber(prompt:sub(find_colon + 1))
            if type(lnum) == "number" then
              local win = picker.previewer.state.winid
              local bufnr = picker.previewer.state.bufnr
              local line_count = vim.api.nvim_buf_line_count(bufnr)
              vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
            end
          end)
          return { prompt = ret }
        end
      end,
      attach_mappings = function()
        actions.select_default:enhance({
          post = function()
            -- if we found something, go to line
            local prompt = action_state.get_current_line()
            local find_colon = string.find(prompt, ":")
            if find_colon then
              local lnum = tonumber(prompt:sub(find_colon + 1))
              vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            end
          end,
        })
        return true
      end,
    },
  },
})

map("n", "<leader>ff", '<cmd>lua require("telescope.builtin").find_files()<cr>')
map("n", "<leader>fr", '<cmd>lua require("telescope.builtin").registers()<cr>')
map("n", "<leader>fg", '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map("n", "<leader>fb", '<cmd>lua require("telescope.builtin").buffers()<cr>')
map("n", "<leader>fh", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map("n", "<leader>fi", '<cmd>lua require("telescope.builtin").file_browser()<cr>')
map("n", "<leader>fs", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>')
map("n", "<leader>git", '<cmd>lua require("telescope.builtin").git_status()<cr>')
