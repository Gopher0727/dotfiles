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

MISSING=()

info "检查软件包..."
for pkg in "${PACKAGES[@]}"; do
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
