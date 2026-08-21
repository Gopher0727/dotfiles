# ~/.zshrc

source ~/.zsh_path              # 环境变量（PATH / SDKMAN / Cargo）

# 插件 (git submodule)
source $HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 历史命令优化
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory     # 追加历史而非覆盖
setopt sharehistory      # 多终端共享历史
setopt histignorealldups # 去重历史命令
setopt histignorespace   # 空格开头的命令不记入历史

# 补全优化
FPATH=$HOME/dotfiles/zsh/plugins/zsh-completions/src:$FPATH
autoload -Uz compinit && compinit
setopt completealiases                              # 别名补全
setopt autocd                                       # 自动跳转
zstyle ':completion:*' menu select                  # 按 Tab 弹出交互式选择菜单（上下键选补全项）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大小写不敏感

# 交互模式允许注释
setopt interactive_comments

# 双击 ESC 添加/移除 sudo
sudo-command-line() {
        [[ -z $BUFFER ]] && zle up-history
        if [[ $BUFFER == sudo\ * ]]; then
                LBUFFER="${LBUFFER#sudo }"
        else
                LBUFFER="sudo $LBUFFER"
        fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# yazi: 退出时自动 cd 到浏览目录
function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" # 临时文件存 yazi 退出路径
        EDITOR=micro yazi "$@" --cwd-file="$tmp"   # 启动 yazi，退出写路径到 $tmp
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}

# lsd: 默认以树形结构展示，深度默认为 2
lt() {
        local depth=2
        local -a args
        while (($#)); do
                if [[ $1 == -d ]]; then
                        depth=$2
                        shift 2
                else
                        args+=("$1")
                        shift
                fi
        done
        command lsd --tree --depth "$depth" "$@"
}

eval "$(zoxide init zsh)"

# API-Key
[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

source $HOME/dotfiles/zsh/plugins/spaceship-prompt/spaceship.zsh

# alias
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

# Dracula 主题 - 对应 fish_color_*
ZSH_HIGHLIGHT_STYLES[command]="fg=#8be9fd,bold"                  # fish_color_command
ZSH_HIGHLIGHT_STYLES[precommand]="fg=#8be9fd,bold"               # sudo, nice, etc.
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[keyword]="fg=#ff79c6"                       # fish_color_keyword
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#ff5555"                 # fish_color_error
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=#ffb86c"          # fish_color_option
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=#ffb86c"          # fish_color_option
ZSH_HIGHLIGHT_STYLES[path]="fg=#bd93f9,underline"                # fish_color_param + fish_color_valid_path
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#f1fa8c"        # fish_color_quote
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#f1fa8c"        # fish_color_quote
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#f1fa8c"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=#ff79c6" # fish_color_escape
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=#ff79c6"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=#f8f8f2"                   # fish_color_redirection
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#ffb86c"              # fish_color_end (;、&、|)
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#50fa7b"                      # fish_color_operator
ZSH_HIGHLIGHT_STYLES[comment]="fg=#6272a4"                       # fish_color_comment
ZSH_HIGHLIGHT_STYLES[assign]="fg=#50fa7b"                        # fish_color_operator
ZSH_HIGHLIGHT_STYLES[default]="fg=#bd93f9"                       # fish_color_param
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6272a4"                     # fish_color_autosuggestion
