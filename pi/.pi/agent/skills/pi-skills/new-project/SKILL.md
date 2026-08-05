---
name: new-project
description: Scaffold new software projects following the user's toolchain conventions. C/C++ projects use xmake (C++23+ via cxxlatest, clang toolchain from Homebrew LLVM set in xmake.lua, precompiled std.pcm for `import std;`, compile_commands.json autoupdate). Python projects use uv (uv init, uv add, uv run). Rust projects use cargo with --vcs none — never git init. Use this skill whenever the user asks to create, scaffold, init, or generate any new project or project directory, e.g. "建一个 Python 项目", "用 cargo 新建项目", "新建 C++ 工程", "用 xmake 建个项目", "帮我初始化一个项目", even if they don't name the tool explicitly.
---

# 新项目生成

用户要求创建新项目（C/C++、Python、Rust）时使用本技能。按语言路由到对应参考文件：

| 语言   | 工具                            | 参考                                                   |
| ------ | ------------------------------- | ------------------------------------------------------ |
| C      | xmake                           | [references/c-project.md](references/c-project.md)     |
| C++    | xmake                           | [references/cpp-project.md](references/cpp-project.md) |
| Python | uv                              | [references/python-uv.md](references/python-uv.md)     |
| Rust   | cargo（`--vcs none`，不要 git） | [references/rust-cargo.md](references/rust-cargo.md)   |
| Go     | `go run`（不编译二进制）        | [references/go-run.md](references/go-run.md)           |

## 通用流程

1. 确认项目名和语言；用户没说语言时先问（或从上下文推断，如文件名后缀）。
2. 按对应参考文件创建项目：写配置 → 写源码 → 构建/运行验证（至少跑通一次：
   `xmake run` / `uv run` / `cargo run`）。
3. **不主动创建 git 仓库**（Rust 必须 `--vcs none`；其他语言同样保持不 git init，
   用户明确要求时才建）。

## 硬性约定（不要省略）

- C++：`add_languages("cxxlatest")` + `set_toolchains("clang")`（写进 xmake.lua，
  不能只靠 `xmake f --toolchain=clang`，切换 debug/release 时配置会被重置）
  - `add_cxxflags("-fmodule-file=std=std.pcm")` + 根目录 std.pcm（用
    `scripts/build_std_pcm.sh` 生成）+ compile_commands autoupdate。
- Python：只用 uv 生态（uv init / uv add / uv run），不用 pip、不手动建 venv；
  `uv init` 必须带 `--vcs none`（uv 默认会建 git 仓库）。
- Rust：`cargo new <name> --vcs none`，绝不 git init。
- Go：`go mod init` + `go run`（`go run main.go` / `go run .`），**不 `go build` 产二进制**，
  避免污染目录结构。

## 已知坑

- std.pcm 与编译器版本/选项强绑定，必须用构建同款 clang 生成，否则报
  `module file config mismatch`。
- AppleClang（macOS 默认）不支持 std 模块方案，`import std;` 报
  `unknown type name 'import'`；出现此错误先查工具链。
- `scripts/build_std_pcm.sh` 报找不到 std.cppm 时，提示用户安装 Homebrew LLVM
  （`brew install llvm`）；脚本会依次检查多个常见路径。
- `go/AGENTS.md` 是算法竞赛工作区专用约定（make build 产 bin/main、make run、
  goimports-reviser 等），仅限该工作区；普通 Go 项目一律 `go run`，不产二进制。
