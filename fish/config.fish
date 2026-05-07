# ~/.config/fish/config.fish
if status is-interactive
# Commands to run in interactive sessions can go here
end

# 别名
alias c="clear"
alias e="exit"
alias cd="z"
alias l="command ls"
alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="lsd -la"
alias cat="bat"
alias fastfetch="fastfetch --config examples/25"

# zoxide 初始化
zoxide init fish | source

# starship 初始化
starship init fish | source

# yazi 退出时切换目录
function y
    set tmp (mktemp -t yazi-cwd.XXXXXX)
    env EDITOR=micro yazi $argv --cwd-file="$tmp"
    if test -s $tmp
        set cwd (cat $tmp)
        if test "$cwd" != "$PWD"
            cd $cwd
        end
    end
    rm -f $tmp
end
