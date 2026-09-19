#!/bin/bash
set -e

# 仓库根目录
cd "$(dirname "$0")"

# 把 <pkg> 装到 <target>
# 冲突的旧文件先备份成 .bak，已经是软链的交给 stow 接管
stow_pkg() {
        mkdir -p "$2"
        for e in "$1"/* "$1"/.[!.]*; do
                n="${e##*/}"
                [ -e "$e" ] || continue
                [ "$n" = .stow-local-ignore ] || grep -qxF "$n" "$1/.stow-local-ignore" 2>/dev/null && continue
                [ ! -e "$2/$n" ] || [ -L "$2/$n" ] || mv "$2/$n" "$2/$n.bak"
        done
        stow "$1" -t "$2"
}

# ~/.config/<tool>
for t in ghostty nvim yazi; do stow_pkg "$t" "$HOME/.config/$t"; done

# ~/<dotfile>
for t in zsh tmux vim git emacs wezterm; do stow_pkg "$t" "$HOME"; done

# clangd 用户级配置
# macOS 只读 ~/Library/Preferences/clangd
clangd_dir="${XDG_CONFIG_HOME:-$HOME/.config}/clangd"
[ "$(uname -s)" = Darwin ] && clangd_dir="$HOME/Library/Preferences/clangd"
stow_pkg clangd "$clangd_dir"

# yazi 配置
command -v ya >/dev/null && ya pkg install >/dev/null || true
