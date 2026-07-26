# ~/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

# 常用 PATH
# 个人开发工具
export PATH="/opt/dev:$PATH"
# latex 环境
export PATH="/usr/local/texlive/2026/bin/universal-darwin:$PATH"
# Go 环境
export PATH="$HOME/go/bin:$PATH"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
