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
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt = true}
paq {'neoclide/coc.nvim', branch = 'release'}

-------------------- COC -------------------------------
-- TextEdit might fail if hidden is not set.
opt.hidden = true
-- Some servers have issues with backup files, see #649.
opt.backup = false
opt.writebackup = false
-- Give more space for displaying messages.
opt.cmdheight=2
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime=300
-- Don't pass messages to |ins-completion-menu|.
vim.cmd('set shortmess+=c')
-- <Tab> to navigate the completion menu
--map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
--map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
--vim.cmd('inoremap <silent><expr> <TAB> pumvisible() ? "\\<C-n>" : <SID>check_back_space() ? "\\<TAB>" : coc#refresh()')
--vim.cmd('inoremap <expr><S-TAB> pumvisible() ? "\\<C-p>" : "\\<C-h>"')
-- Use <c-space> to trigger completion.
--map('i', '<C-i>', 'coc#refresh()', {expr = true})


map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes