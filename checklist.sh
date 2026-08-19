#!/bin/bash
set -e

error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; }
info() { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }

PACKAGES=(
        nvim vim emacs
        ghostty
        uv ruff rustup clangd
        git stow yazi zoxide lsd fzf bat tmux tokei
        fastfetch btop tree rg fd jq duf dust
        shfmt prettier
)

EXTRA_TOOLS=(
        rust-analyzer               # rustup component add rust-analyzer
        pyright                     # pip install pyright 或 brew install pyright
        gopls                       # go install golang.org/x/tools/gopls@latest
        goimports                   # go install golang.org/x/tools/cmd/goimports@latest
        bash-language-server        # npm i -g bash-language-server
        vscode-json-language-server # npm i -g vscode-langservers-extracted
)

MISSING=()

info "检查软件包..."
for pkg in "${PACKAGES[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
                MISSING+=("$pkg")
        fi
done

info "检查 LSP / 格式化工具..."
for pkg in "${EXTRA_TOOLS[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
                MISSING+=("$pkg")
        fi
done

if ((${#MISSING[@]} > 0)); then
        error "未安装:"
        for pkg in "${MISSING[@]}"; do
                echo "  - $pkg"
        done
else
        info "已全部安装"
fi
