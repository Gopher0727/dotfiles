unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! comment
packadd! matchit
packadd! hlyank
packadd! editorconfig

set nu
set rnu
set cul
set ls=2

set ignorecase
set smartcase

let &statusline = ' %f %h%m%r%= %{&filetype} | %l:%c | %p%% '

set clipboard=unnamed

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
