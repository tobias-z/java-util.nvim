" Grabbing source code
set rtp+=.

" Using local versions of plenary and nvim-treesitter if possible
" This is required for CI
set rtp+=../plenary.nvim
set rtp+=../nvim-treesitter
set rtp+=../nvim-jdtls

" Luasnip is not a requirement for the plugin, but it is used during building
" of test snapshots
set rtp+=../LuaSnip

" If you use vim-plug if you got it locally
set rtp+=~/.vim/plugged/plenary.nvim
set rtp+=~/.vim/plugged/nvim-treesitter
set rtp+=~/.vim/plugged/nvim-jdtls
set rtp+=~/.vim/plugged/LuaSnip

" If you are using packer
set rtp+=~/.local/share/nvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-jdtls
set rtp+=~/.local/share/nvim/site/pack/packer/start/LuaSnip

" If you are using lunarvim
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/nvim-jdtls
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/LuaSnip

runtime! plugin/plenary.vim
runtime! plugin/nvim-treesitter.lua
runtime! plugin/nvim_jdtls.vim
runtime! plugin/luasnip.vim
