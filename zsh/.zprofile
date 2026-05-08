# ~/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# 常用 PATH
# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
# 个人开发工具
export PATH="/opt/dev:$PATH"
# latex 环境
export PATH="/usr/local/texlive/2026/bin/universal-darwin:$PATH"
# Go 环境
export PATH="$HOME/go/bin:$PATH"
# Java 环境
export JAVA_HOME="$(brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
