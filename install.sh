#!/bin/bash
# dotfiles 安装器：按包安装，默认硬链接；-s 软链接，-u 卸载。
set -euo pipefail

usage() {
	cat <<'EOF'
usage: install.sh [options] <package>...

packages:
  all      全部
  zsh tmux git emacs vim ghostty yazi clangd

options:
  -s, --symlink     使用软链接（默认硬链接）
  -u, --uninstall   删除链接并恢复 *.bak
  -h, --help        显示帮助（默认）
EOF
}

repo_root=$(cd -- "$(dirname -- "$0")" && pwd -P)
action=install
link_type=hard
packages=()

while [ $# -gt 0 ]; do
	case $1 in
	-s | --symlink) link_type=symlink ;;
	-u | --uninstall) action=uninstall ;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		usage >&2
		exit 2
		;;
	*) packages+=("$1") ;;
	esac
	shift
done

if [ ${#packages[@]} -eq 0 ]; then
	usage
	exit 0
fi

for pkg in "${packages[@]}"; do
	case $pkg in
	all | zsh | tmux | git | emacs | vim | ghostty | yazi | clangd) ;;
	*)
		printf 'unknown package: %s\n' "$pkg" >&2
		usage >&2
		exit 2
		;;
	esac
done

selected() {
	local pkg
	for pkg in "${packages[@]}"; do
		if [ "$pkg" = all ] || [ "$pkg" = "$1" ]; then
			return 0
		fi
	done
	return 1
}

warn() { printf 'warning: %s\n' "$*" >&2; }

# 备份已有目标；如果 .bak 已存在，先把它改成带时间戳的名字。
backup_file() {
	local dst=$1

	if [ -e "$dst.bak" ] || [ -L "$dst.bak" ]; then
		mv -- "$dst.bak" "$dst.bak.$(date +%s)"
	fi
	mv -- "$dst" "$dst.bak"
}

# 安装单个文件：让 dst 指向 src。
link_file() {
	local src=$1 dst=$2

	mkdir -p -- "$(dirname -- "$dst")"

	# 已经是指向 src 的硬链接 / 软链接。
	if [ "$src" -ef "$dst" ] && [ ! -L "$dst" ]; then
		if [ "$link_type" = hard ]; then
			return
		fi
		rm -- "$dst"
	elif [ -L "$dst" ] && [ "$(readlink -- "$dst")" = "$src" ]; then
		if [ "$link_type" = symlink ]; then
			return
		fi
		rm -- "$dst"
	elif [ -e "$dst" ] || [ -L "$dst" ]; then
		# 普通文件先备份；指向别处的旧软链接直接删。
		if [ -L "$dst" ]; then
			rm -- "$dst"
		else
			backup_file "$dst"
		fi
	fi

	if [ "$link_type" = symlink ]; then
		ln -s -- "$src" "$dst"
	elif ! ln -- "$src" "$dst" 2>/dev/null; then
		warn "hard link failed, falling back to symlink: $dst"
		ln -s -- "$src" "$dst"
	fi
}

# 卸载单个文件：只删指向 src 的链接，本机改过的文件保留。
unlink_file() {
	local src=$1 dst=$2

	if [ -L "$dst" ] && [ "$(readlink -- "$dst")" = "$src" ]; then
		rm -- "$dst"
	elif [ ! -L "$dst" ] && [ "$src" -ef "$dst" ]; then
		rm -- "$dst"
	elif [ -e "$dst" ] || [ -L "$dst" ]; then
		warn "skip modified file: $dst"
		return
	fi

	if [ -e "$dst.bak" ] || [ -L "$dst.bak" ]; then
		mv -- "$dst.bak" "$dst"
	fi
}

apply_file() {
	if [ "$action" = install ]; then
		link_file "$1" "$2"
	else
		unlink_file "$1" "$2"
	fi
}

# 处理包目录下的顶层文件；plugins 等子目录不处理。
apply_package() {
	local src_dir=$1 target_dir=$2
	local src name

	for src in "$src_dir"/* "$src_dir"/.[!.]*; do
		[ -f "$src" ] || continue
		name=${src##*/}
		case $name in
		.stow-local-ignore | *.bak | *~ | .DS_Store) continue ;;
		esac
		apply_file "$src" "$target_dir/$name"
	done
}

# 维护固定入口 ~/.config/dotfiles -> 仓库，供 zsh 等配置定位插件。
sync_repo_link() {
	local dst=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles

	if [ "$action" = uninstall ]; then
		if [ -L "$dst" ]; then
			rm -- "$dst"
		fi
		return
	fi

	mkdir -p -- "$(dirname -- "$dst")"

	if [ -L "$dst" ]; then
		if [ "$(readlink -- "$dst")" = "$repo_root" ]; then
			return
		fi
		rm -- "$dst"
	elif [ -e "$dst" ]; then
		warn "skip existing path: $dst"
		return
	fi

	ln -s -- "$repo_root" "$dst"
}

# ~/.zshrc、~/.gitconfig、~/.vimrc 等
for pkg in zsh tmux git emacs vim; do
	if selected "$pkg"; then
		apply_package "$repo_root/$pkg" "$HOME"
	fi
done

# ~/.config/ghostty、~/.config/yazi
for pkg in ghostty yazi; do
	if selected "$pkg"; then
		apply_package "$repo_root/$pkg" "$HOME/.config/$pkg"
	fi
done

# clangd 的用户级配置路径和平台有关。
if selected clangd; then
	clangd_dir=$HOME/.config/clangd
	if [ "$(uname -s)" = Darwin ]; then
		clangd_dir=$HOME/Library/Preferences/clangd
	fi
	apply_file "$repo_root/clangd/config.yaml" "$clangd_dir/config.yaml"
fi

# zsh 通过这个链接定位仓库里的插件。
if selected zsh; then
	sync_repo_link
fi

# 安装时初始化依赖，卸载时不动它们。
if [ "$action" = install ]; then
	if selected zsh; then
		git -C "$repo_root" submodule update --init --recursive --quiet ||
			warn "git submodule update failed"
	fi
	if selected yazi && command -v ya >/dev/null; then
		ya pkg install >/dev/null || warn "ya pkg install failed"
	fi
fi
