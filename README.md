# 常用 OS 配置

将该仓库克隆到用户根目录，执行 [install.sh](./install.sh) 即可。

```bash
git clone --recurse-submodules git@github.com:Gopher0727/dotfiles.git
```

或者，可以

```bash
git config --global alias.clone-sub 'clone --recurse-submodules'

git clone-sub git@github.com:Gopher0727/dotfiles.git
```

软件包列表见 [checklist.sh](./checklist.sh)。

## Git

```bash
# 当上次提交还没有推送/合入，amend 会在上次提交基础上更新
# 否则，远端有了提交，本地生成新的提交，会和远程分叉
git commit --amend

git ls-files --eol
git add --renormalize . # 强制重新规范化
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
