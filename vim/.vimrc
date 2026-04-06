syntax on

" 插件
call plug#begin('~/.vim/plugged')
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " 多光标插件
call plug#end()

set number
set relativenumber
set cursorline

set nocompatible

"主题
set termguicolors
colorscheme catppuccin_mocha

"缩进
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

"搜索
set ignorecase
set smartcase
set incsearch
set hlsearch

"剪贴板
set clipboard=unnamedplus

