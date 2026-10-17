#!/bin/bash
# dotfiles 安装器：默认硬链接，-s 软链接，-u 卸载。
set -euo pipefail

usage() {
	cat <<'EOF'
usage: install.sh [-s|--symlink] [-u|--uninstall]

  -s, --symlink     使用软链接（默认硬链接）
  -u, --uninstall   删除链接并恢复 *.bak
EOF
}

repo_root=$(cd -- "$(dirname -- "$0")" && pwd -P)
action=install
link_type=hard

while [ $# -gt 0 ]; do
	case $1 in
	-s | --symlink) link_type=symlink ;;
	-u | --uninstall) action=uninstall ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		usage >&2
		exit 2
		;;
	esac
	shift
done

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

# ~/.zshrc、~/.gitconfig、~/.vimrc 等
for pkg in zsh tmux git emacs vim; do
	apply_package "$repo_root/$pkg" "$HOME"
done

# ~/.config/ghostty、~/.config/yazi
for pkg in ghostty yazi; do
	apply_package "$repo_root/$pkg" "$HOME/.config/$pkg"
done

# clangd 的用户级配置路径和平台有关。
clangd_dir=$HOME/.config/clangd
if [ "$(uname -s)" = Darwin ]; then
	clangd_dir=$HOME/Library/Preferences/clangd
fi
apply_file "$repo_root/clangd/config.yaml" "$clangd_dir/config.yaml"

# 安装时初始化依赖，卸载时不动它们。
if [ "$action" = install ]; then
	git -C "$repo_root" submodule update --init --recursive --quiet ||
		warn "git submodule update failed"
	if command -v ya >/dev/null; then
		ya pkg install >/dev/null || warn "ya pkg install failed"
	fi
fi
