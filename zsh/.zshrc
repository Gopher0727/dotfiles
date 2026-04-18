# 历史命令优化
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory         # 追加历史而非覆盖
setopt sharehistory          # 多终端共享历史
setopt histignorealldups     # 去重历史命令
setopt histignorespace       # 空格开头的命令不记入历史

# 补全优化
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select # 按 Tab 弹出交互式选择菜单（上下键选补全项）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大小写不敏感
setopt completealiases # 别名补全
setopt autocd # 自动跳转

# alias
alias cd="z"
alias l="command ls"
alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="lsd -la"
alias cat="bat"
alias fastfetch="fastfetch --config examples/25"

# zoxide 初始化
eval "$(zoxide init zsh)"

# starship 初始化
eval "$(starship init zsh)"

# 环境变量
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/usr/local/texlive/2026/bin/universal-darwin:$PATH"

<<<<<<< HEAD
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
=======
# yazi 退出时切换目录
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	EDITOR=micro yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
>>>>>>> a38cbf4 (add y wrapper)

# 插件
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/plugins/zsh-history-substring-search
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # 自动补全
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh # 历史子串搜索
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # 语法高亮

# Dracula 主题 - 对应 fish_color_*
ZSH_HIGHLIGHT_STYLES[command]="fg=#8be9fd,bold"                     # fish_color_command
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#8be9fd,bold"
ZSH_HIGHLIGHT_STYLES[keyword]="fg=#ff79c6"                          # fish_color_keyword
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#ff5555"                    # fish_color_error
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=#ffb86c"             # fish_color_option
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=#ffb86c"             # fish_color_option
ZSH_HIGHLIGHT_STYLES[path]="fg=#bd93f9,underline"                   # fish_color_param + fish_color_valid_path
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#f1fa8c"           # fish_color_quote
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#f1fa8c"           # fish_color_quote
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=#f1fa8c"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=#ff79c6"    # fish_color_escape
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=#ff79c6" 
ZSH_HIGHLIGHT_STYLES[redirection]="fg=#f8f8f2"                      # fish_color_redirection
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#ffb86c"                 # fish_color_end (;、&、|)
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#50fa7b"                         # fish_color_operator
ZSH_HIGHLIGHT_STYLES[comment]="fg=#6272a4"                          # fish_color_comment
ZSH_HIGHLIGHT_STYLES[assign]="fg=#50fa7b"                           # fish_color_operator
ZSH_HIGHLIGHT_STYLES[default]="fg=#bd93f9"                          # fish_color_param
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6272a4"                        # fish_color_autosuggestion
