# ~/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

# 常用 PATH
# 个人开发工具
export PATH="/opt/dev:$PATH"
# latex 环境
export PATH="/usr/local/texlive/2026/bin/universal-darwin:$PATH"
# Go 环境
export PATH="$HOME/go/bin:$PATH"
# Java 环境
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
