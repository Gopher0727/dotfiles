#!/bin/bash
set -e

error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; }
info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }

PACKAGES=(
  ghostty git stow yazi zoxide lsd fzf bat nvim vim tldr tmux tokei
  fastfetch btop tree ccache rg fd jq duf dust
  uv ruff rustup
)

MISSING=()

info "检查软件包..."
for pkg in "${PACKAGES[@]}"; do
  if ! command -v "$pkg" &>/dev/null; then
    MISSING+=("$pkg")
  fi
done

if (( ${#MISSING[@]} > 0 )); then
  error "以下软件包未安装:"
  for pkg in "${MISSING[@]}"; do
    echo "  - $pkg"
  done
fi
info "所有软件包均已安装..."
