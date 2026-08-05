# Rust 项目（cargo）

用 cargo 创建项目，**永远不要 git**：必须加 `--vcs none`，之后也不要 `git init`。
用户要 git 仓库时会明确说。

## 创建

```bash
cargo new <项目名> --vcs none    # 生成 Cargo.toml（edition 2024）+ src/main.rs，无 .git
```

- 默认二进制项目；库项目用 `cargo new <name> --lib --vcs none`。
- 即使当前目录已在某个 git 仓库内，也照常用 `--vcs none`（保持子项目干净）。

## 运行

```bash
cargo run
```

## 验证

`cargo run` 打印 "Hello, world!"（或用户要求的输出）即成功。
