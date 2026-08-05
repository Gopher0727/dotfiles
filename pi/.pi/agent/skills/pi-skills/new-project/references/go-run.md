# Go 项目（go run，不产二进制）

普通 Go 项目遵循：**用 `go run` 运行，不要编译出二进制文件**，避免污染项目目录结构。

## 初始化

```bash
go mod init <module名>    # 生成 go.mod，然后写 main.go（main 包）
```

## 运行（用 go run，不要 go build）

```bash
go run main.go            # 整体单文件
go run .                  # 当前目录的 main 包
go run ./cmd/<tool>       # tool/工具型子包
```

- 工具型、脚本型项目一律 `go run`，运行完项目内不留下任何产物。
- 不要在项目目录里执行 `go build`（会在目录里生成可执行二进制，污染文件结构）。
- 确实需要构建时把产物放项目外：`go build -o /tmp/<name> .`；或 `go install`
  （装到 GOBIN，项目内无产物）。
- 如果项目里误出现了二进制文件，直接删除。

## 验证

`go run .` 输出正常即成功；确认项目目录内没有可执行二进制文件。

## 例外

`go/AGENTS.md`（算法竞赛工作区）是特例：它用 `make build` 产出 `bin/main`、
`make run` 运行，还涉及 goimports-reviser、测试数据等竞赛专用约定——只在该工作区
生效，普通 Go 项目不适用，不要照搬。
