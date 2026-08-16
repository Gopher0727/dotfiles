#!/bin/bash
set -e

# ~/.config/*
stow_config=(ghostty nvim yazi)

for name in "${stow_config[@]}"; do
        src="$HOME/.config/$name"

        [ ! -e "$src" ] || mv "$src" "$src.bak" && mkdir -p "$src"

        stow "$name" -t "$src"
done

# ~/*
stow_home=(.zshrc .zsh_path .tmux.conf .vimrc .emacs)

for conf in "${stow_home[@]}"; do
        [ ! -e "$HOME/$conf" ] || mv "$HOME/$conf" "$HOME/$conf.bak"
done

stow zsh tmux vim emacs -t ~
