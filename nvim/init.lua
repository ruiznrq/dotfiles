-------------------- HELPERS -------------------------------
-- local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
-- local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
-- local g = vim.g      -- a table to access global variables
-- local opt = vim.opt  -- to set options

require('packer').startup(function()
   -- Packer can manage itself
   use 'wbthomason/packer.nvim'

   use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
   }

   use 'neovim/nvim-lspconfig'

   use 'nvim-lua/completion-nvim'
end)

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "c_sharp", "cpp", "lua", "rust", "zig" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

-- Enable rust_analyzer
require'lspconfig'.rust_analyzer.setup({ on_attach=on_attach })