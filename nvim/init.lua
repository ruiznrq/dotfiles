require('packer').startup(function()
   -- Packer can manage itself
   use 'wbthomason/packer.nvim'

   use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
   }

   use 'neovim/nvim-lspconfig'

   -- Install nvim-cmp, and buffer source as a dependency
   use {
   "hrsh7th/nvim-cmp",
   requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer",
   }
   }
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

require'lspconfig'.rust_analyzer.setup({})

  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {}
  })