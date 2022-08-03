" Grabbing source code
set rtp+=.

" Using local versions of plenary and nvim-treesitter if possible
" This is required for CI
set rtp+=../plenary.nvim
set rtp+=../nvim-treesitter
set rtp+=../nvim-jdtls

" If you use vim-plug if you got it locally
set rtp+=~/.vim/plugged/plenary.nvim
set rtp+=~/.vim/plugged/nvim-treesitter
set rtp+=~/.vim/plugged/nvim-jdtls

" If you are using packer
set rtp+=~/.local/share/nvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-jdtls

" If you are using lunarvim
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/nvim-jdtls

runtime! plugin/plenary.vim
runtime! plugin/nvim-treesitter.lua
runtime! plugin/nvim_jdtls.vim
