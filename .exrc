" LearningGo - Neovim Project Configuration
" This file provides which-key mappings under <leader>p
" Load with: set exrc secure

" Ensure we're in the right directory
if getcwd() !~# 'LearningGo'
  finish
endif

" Project-specific settings
setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab
setlocal autoindent

" Load the Lua configuration
lua dofile(vim.fn.getcwd() .. '/.nvim.lua')
