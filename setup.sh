#!/bin/bash
set -e

# ========== 自定义软件包列表 ==========
# macOS (Homebrew)
BREW_PACKAGES=(
  git stow yazi starship zoxide fastfetch vim neovim
  tldr tmux btop lsd fzf tree ccache cloc ripgrep fd jq duf bat
  uv ruff
)
BREW_CASK_PACKAGES=(ghostty kitty font-fira-code-nerd-font)

# Arch Linux (pacman)
PACMAN_PACKAGES=(
  git stow yazi starship zoxide fastfetch vim neovim
  tldr tmux btop lsd fzf tree ccache cloc ripgrep fd jq duf bat
  openssh zsh fish
  uv ruff
)

# stow 部署目录
STOW_PACKAGES=(nvim tmux vim yazi zsh)

# 需要创建的配置目录
CONFIG_DIRS=(
  ~/.config/nvim
  ~/.config/ghostty
  ~/.config/yazi
  ~/.config/fish
  ~/.config/helix
  ~/.config/micro
)
# ==========================================

error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; }
info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn()  { echo -e "\033[0;33m[WARN]\033[0m $1"; }

# 获取脚本所在目录
if [[ -n "${BASH_SOURCE[0]}" ]]; then
  DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")")" && pwd)"
else
  DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

# 检测操作系统
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="mac" ;;
  Linux)
    if [[ -f /etc/arch-release ]]; then
      PLATFORM="arch"
    else
      error "暂不支持此 Linux 发行版（仅支持 Arch Linux）"
      exit 1
    fi
    ;;
  *)
    error "不支持的操作系统: $OS"
    exit 1
    ;;
esac

info "检测到平台: $PLATFORM"

# 1. 创建所需目录（已有则备份为 .bak）
info "创建配置目录..."
for dir in "${CONFIG_DIRS[@]}"; do
  dir="${dir/#\~/$HOME}"
  if [[ -d "$dir" ]]; then
    warn "$dir 已存在，备份为 ${dir}.bak"
    [[ -d "${dir}.bak" ]] && rm -rf "${dir}.bak"
    mv "$dir" "${dir}.bak"
  fi
  mkdir -p "$dir"
done
info "目录创建完成"

# 2. 安装软件包
FAILED_PACKAGES=()

install_mac() {
  if ! command -v brew &>/dev/null; then
    error "未检测到 Homebrew，请先安装: https://brew.sh"
    exit 1
  fi

  info "开始安装 brew formula..."
  for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
      warn "$pkg 已安装，跳过"
    else
      info "安装 $pkg ..."
      if ! brew install "$pkg"; then
        error "$pkg 安装失败"
        FAILED_PACKAGES+=("$pkg")
      fi
    fi
  done

  info "开始安装 brew cask..."
  for pkg in "${BREW_CASK_PACKAGES[@]}"; do
    if brew list --cask "$pkg" &>/dev/null; then
      warn "$pkg (cask) 已安装，跳过"
    else
      info "安装 $pkg (cask) ..."
      if ! brew install --cask "$pkg"; then
        error "$pkg (cask) 安装失败"
        FAILED_PACKAGES+=("$pkg")
      fi
    fi
  done
}

install_arch() {
  info "更新系统..."
  sudo pacman -Syu --noconfirm

  info "开始安装软件包..."
  for pkg in "${PACMAN_PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      warn "$pkg 已安装，跳过"
    else
      info "安装 $pkg ..."
      if ! sudo pacman -S --noconfirm "$pkg"; then
        error "$pkg 安装失败"
        FAILED_PACKAGES+=("$pkg")
      fi
    fi
  done
}

if [[ "$PLATFORM" == "mac" ]]; then
  install_mac
else
  install_arch
fi

# 3. 检查安装结果
if (( ${#FAILED_PACKAGES[@]} > 0 )); then
  error "以下软件包安装失败: ${FAILED_PACKAGES[*]}"
  error "中止 stow 配置，请修复后重试"
  exit 1
fi
info "所有软件包安装成功"

# 4. Arch: 将 zsh 设为默认 shell
if [[ "$PLATFORM" == "arch" ]]; then
  ZSH_PATH="$(command -v zsh)"
  if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    info "将默认 shell 切换为 zsh ($ZSH_PATH)..."
    chsh -s "$ZSH_PATH"
    info "默认 shell 已设为 zsh（重新登录后生效）"
  else
    warn "当前默认 shell 已是 zsh，跳过"
  fi
fi

# 5. 使用 stow 部署配置
info "开始 stow 配置..."
cd "$DOTFILES_DIR"

for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    info "stow $pkg"
    stow --restow "$pkg"
  else
    warn "目录 $pkg 不存在，跳过"
  fi
done

info "全部完成!"
