# AGENTS.md

## Project type

Competitive programming workspace. Single-package Go module with stdin/stdout I/O.

## Commands

- Build: `make build` (outputs to `bin/main`)
- Run: `make run` (builds then runs `./bin/main`)
- Format: `make fmt` (uses `goimports-reviser`, not `gofmt`/`goimports`)
- Tidy deps: `make tidy` (`go mod tidy`)
- Clean: `make clean` (removes `bin/` and `.cph/`)

## Formatter

Uses `goimports-reviser` (`go install github.com/incu6us/goimports-reviser/v2@latest`). Standard `gofmt`/`goimports` are not sufficient — run `make fmt`.

## Dependencies

`go.mod` lists dependencies (`gin-gonic/gin`, `mongo-driver`, etc.) not imported in `main.go`. Do not add or remove dependencies without explicit request. `go mod tidy` will strip unused deps — only run when asked.

## I/O conventions

- Input via `bufio.NewReader(os.Stdin)` with `fmt.Fscan`
- Output via `bufio.NewWriter(os.Stdout)` with `fmt.Fprintln`/`fmt.Fprint`
- Test data: save input as `data/<name>.in`, expected output as `data/<name>.out`
- Verify: `make check` (all tests) or `make check SAMPLE=<name>` (single)
- Code templates at `.vscode/template_go.code-snippets`

## Code templates

### Multi-testcase (T 组数据)

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

var (
	in  = bufio.NewReader(os.Stdin)
	out = bufio.NewWriter(os.Stdout)
)

func solve() {

}

func main() {
	defer out.Flush()

	var T int
	fmt.Fscan(in, &T)

	for range T {
		solve()
	}
}
```

### Single-testcase (单组数据)

```go
package main

import (
	"bufio"
	"os"
)

var (
	in  = bufio.NewReader(os.Stdin)
	out = bufio.NewWriter(os.Stdout)
)

func solve() {

}

func main() {
	defer out.Flush()

	solve()
}
```

## Naming conventions

| 含义          | 变量名               |
| ------------- | -------------------- |
| 数组长度/规模 | `n`, `m`, `k`        |
| 循环/临时下标 | `i`, `j`, `t`        |
| 主数组        | `a`, `b`, `c`        |
| 坐标          | `x`, `y`, `z`        |
| 网格图        | `g`                  |
| 字符串        | `s`                  |
| 图邻接表      | `adj`, `g`           |
| 图边          | `e`, `edges`         |
| 图节点        | `u`, `v`             |
| 图度数        | `deg`                |
| 答案          | `ans`                |
| 结果          | `res`                |
| 当前值/指针   | `cur`, `p`           |
| 计数          | `cnt`                |
| 总和          | `sum`                |
| 前缀          | `pre`                |
| 后缀          | `suf`                |
| 差值/距离     | `d`                  |
| 位置/下标     | `pos`, `p`           |
| 值            | `val`, `v`           |
| 左/右边界     | `l`, `r`             |
| 模数          | `MOD`                |
| 无穷大        | `inf`                |
| 权重          | `w`                  |
| 并查集父节点  | `pa`                 |
| 集合大小      | `siz`                |
| 访问标记      | `vis`                |
| 颜色标记      | `col`                |
| 栈            | `stk`                |
| 队列          | `q`                  |
| DP 数组       | `dp`, `f`            |
| 深度          | `dep`                |
| 距离          | `dis`, `dist`        |
| 父节点        | `parent`, `pa`, `fa` |
| DFS 序        | `dfn`                |
| 出/入时间     | `in`, `out`          |
| 树剖链顶      | `top`                |
| 重链序号      | `ord`                |
