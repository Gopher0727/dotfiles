# 常用 OS 配置

You could install the following software packages.

- `git` `stow` `yazi` `ghostty kitty` `zsh fish` `starship` `zoxide` `fastfetch` `vim` `nvim`

- `tldr` `tmux` `btop` `lsd` `openssh` `fzf` `tree` `ccache` `cloc` `ripgrep` `fd (find)` `jq` `duf` `cmatrix` `lolcat` `bat`

- `uv` `ruff`

- `reqable` `sublime` `maccy` `mos`

## Git
```bash
# 当上次提交还没有推送/合入，amend 会在上次提交基础上更新
# 否则，远端有了提交，本地生成新的提交，会和远程分叉
git commit --amend

git ls-files --eol
git add --renormalize . # 强制重新规范化
```
