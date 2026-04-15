filetype plugin indent on
syntax on

" 插件
call plug#begin('~/.vim/plugged')
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " 多光标插件
call plug#end()

set number
set relativenumber

set nocompatible
set undofile
set showcmd
set showmode
set mouse=a
set noerrorbells

"分屏
set splitbelow
set splitright

"状态栏
set cursorline
set laststatus=2

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
set showmatch

"剪贴板
set clipboard=unnamedplus

"键位
inoremap jk <ESC>

