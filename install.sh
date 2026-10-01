#!/bin/bash
set -e

# 仓库根目录
cd "$(dirname "$0")"

# ~/.config/*
stow_config=(ghostty yazi)

for name in "${stow_config[@]}"; do
        src="$HOME/.config/$name"
        mkdir -p "$src"
        stow "$name" -t "$src"
done

# ~/*
stow_home=(zsh tmux git emacs)

stow "${stow_home[@]}" -t "$HOME"
