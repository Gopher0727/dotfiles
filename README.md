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

执行 [install.sh](./install.sh) 即可：

```bash
./install.sh          # 默认硬链接
./install.sh -s       # 软链接
./install.sh -u       # 卸载链接并恢复 *.bak
```

软件包列表见 [checklist.sh](./checklist.sh)。

## Yazi

依赖安装与更新：

```bash
ya pkg install     # 按 package.toml 的 rev 装
ya pkg upgrade     # 升级
```

## Git

```bash
# 当上次提交还没有推送/合入，amend 会在上次提交基础上更新
# 否则，远端有了提交，本地生成新的提交，会和远程分叉
git commit --amend

git ls-files --eol
git add --renormalize . # 强制重新规范化

git config --global core.excludesFile ~/.gitignore_global # 全局忽略
```

## C++ / clangd

`install.sh` 会把 `clangd/config.yaml` 链接到 `~/Library/Preferences/clangd/config.yaml`（其他平台为 `~/.config/clangd/config.yaml`）。

`#include <bits/stdc++.h>` 是 GCC(libstdc++) 的私有头文件，macOS 自带的 Apple clang 和 Homebrew LLVM 都不提供。

编译时 Apple clang(`g++`) 默认搜索 `/usr/local/include`，可以通过编译，但 Homebrew 的 clangd 不搜索该路径。

如果以后改用 GCC（`brew install gcc`），要换成给 clangd 传 `--query-driver=/opt/homebrew/bin/g++-*`，并让项目使用 `-stdlib=libstdc++`。
