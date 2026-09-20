# 常用 OS 配置

将该仓库克隆到用户根目录：

```bash
git clone --recurse-submodules git@github.com:Gopher0727/dotfiles.git
```

或者，可以

```bash
git config --global alias.clone-sub 'clone --recurse-submodules'

git clone-sub git@github.com:Gopher0727/dotfiles.git
```

执行 [install.sh](./install.sh) 即可。

软件包列表见 [checklist.sh](./checklist.sh)。

## Nvim

nvim 首次启动会自动装插件，但 blink.cmp 的原生库要手动编译一次（需要 cargo）：

```bash
nvim --headless "+lua require('blink.cmp').build():pwait()" +qa
```

## Vim

需要安装 catppuccin 主题：

```bash
git clone https://github.com/catppuccin/vim ~/.vim/pack/vendor/start/catppuccin
```

它不参与 stow，如果需要升级：

```bash
git -C ~/.vim/pack/vendor/start/catppuccin pull --ff-only
```

## Yazi

```bash
ya pkg install     # 按 package.toml 的 rev 装
ya pkg upgrade     # 升级
```

## C++ / clangd

clangd 的用户级配置：macOS 只读 `~/Library/Preferences/clangd`（其他平台读 `~/.config/clangd`）

```bash
clangd_dir=~/Library/Preferences/clangd                                  # Linux 用 ~/.config/clangd
mkdir -p "$clangd_dir"
stow clangd -t "$clangd_dir"
```

`clangd/config.yaml`  ->  `$clangd_dir/config.yaml`

`#include <bits/stdc++.h>` 是 GCC(libstdc++) 的私有头文件，macOS 自带的 Apple clang 和 Homebrew LLVM 都不提供。

编译时 Apple clang(`g++`) 默认搜索 `/usr/local/include`，可以通过编译；但 Homebrew 的 clangd 不搜索该路径，nvim/emacs(`eglot`) 打开单文件时会出现 `'bits/stdc++.h' file not found`。

如果以后改用 GCC（`brew install gcc`），要换成给 clangd 传 `--query-driver=/opt/homebrew/bin/g++-*`，并让项目使用 `-stdlib=libstdc++`。

## Git

```bash
# 当上次提交还没有推送/合入，amend 会在上次提交基础上更新
# 否则，远端有了提交，本地生成新的提交，会和远程分叉
git commit --amend

git ls-files --eol
git add --renormalize . # 强制重新规范化

git config --global core.excludesFile ~/.gitignore_global # 全局忽略
```

## Xmake

```bash
# 预编译
clang++ -std=c++26 --precompile -o std.pcm /opt/homebrew/opt/llvm/share/libc++/v1/std.cppm

# xmake.lua 中添加
add_languages("cxxlatest")
add_cxxflags("-fmodule-file=std=std.pcm")

# 选择工具链
xmake -f --toolchain=clang # LLVM
```
