unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! comment
packadd! matchit
packadd! hlyank
packadd! editorconfig

colorscheme habamax

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

" shfmt: :Shfmt [args] 或 :'<,'>Shfmt [args]
function! s:Shfmt(args) abort range
	if index(['sh', 'bash', 'zsh', 'posix', 'mksh', 'bats'], &filetype) < 0
		echohl WarningMsg
		echomsg '不是 shell 文件: ' . expand('%')
		echohl None
		return
	endif
	execute printf('%d,%d!shfmt %s', a:firstline, a:lastline, a:args)
endfunction
command! -range=% -nargs=* Shfmt call <SID>Shfmt(<q-args>)
