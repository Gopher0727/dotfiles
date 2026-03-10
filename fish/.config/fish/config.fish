if status is-interactive
# Commands to run in interactive sessions can go here
end

# 别名
alias l="command ls"
alias ls="lsd -l"

# Go 环境
set -Ux PATH /usr/local/go/bin $PATH
set -gx PATH $HOME/go/bin $PATH

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH

# zoxide
zoxide init fish | source

