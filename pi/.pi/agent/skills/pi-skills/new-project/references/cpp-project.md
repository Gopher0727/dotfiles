# C++ 项目模板（xmake.lua）

C++ 项目必须满足：C++23 以上、clang 工具链、预编译 std 模块、compile_commands.json。

```lua
add_rules("mode.debug", "mode.release")
add_rules("plugin.compile_commands.autoupdate", { output = "compile_commands.json" })

target("<project-name>")
    set_kind("binary")
    set_toolchains("clang")
    add_languages("cxxlatest")          -- clang 22 → -std=c++26（C++23 以上）
    add_cxxflags("-fmodule-file=std=std.pcm")
    add_files("src/*.cpp")
```

## 为什么这样写

- **`add_languages("cxxlatest")`**：C++23 以上标准。Homebrew clang 22 解析为 `-std=c++26`。
- **`set_toolchains("clang")`**：强制使用 Homebrew LLVM（`/opt/homebrew/opt/llvm/bin/clang++`），
  而不是 macOS 默认的 AppleClang（AppleClang 的 libc++ 不配套 std 模块，`import std;` 会报
  `unknown type name 'import'`）。
  ⚠️ 不要把工具链放在命令行（`xmake f --toolchain=clang`）：之后执行 `xmake f -m debug` 切换
  模式时配置会被重置回默认工具链。写在 xmake.lua 里则两种模式都稳定生效。
- **`-fmodule-file=std=std.pcm`**：告诉编译器在项目根目录查找预编译的 std 模块。
  源码直接用 `import std;`（不需要 `-fmodules`，clang 22 验证）。
- **compile_commands.autoupdate**：每次构建自动刷新 `compile_commands.json`。

## std.pcm 的生成

```bash
<skill-dir>/scripts/build_std_pcm.sh <项目根目录>
```

- 产物约 34MB，生成约 1 秒。
- 必须用与项目构建相同的 clang 生成（.pcm 与编译器版本强绑定）。
- 依赖 Homebrew LLVM 的 libc++ 模块源：`/opt/homebrew/opt/llvm/share/libc++/v1/std.cppm`。
- 脚本会自动尝试 `-std=c++26`，失败则回退 `-std=c++23`。
- 旧项目的 std.pcm 可以直接复制复用（同编译器版本下），但重新生成更稳妥。

## 源码示例 `src/main.cpp`

```cpp
import std;

int main() {
    std::vector<int> a {10, 3, 1, 2};
    std::ranges::sort(a);
    for (auto v : a) std::print("{} ", v);
    std::println();

    std::println("Hello from <project-name>!");
}
```

## 构建与验证

```bash
cd <项目根目录>
xmake f -m debug      # 或 release
xmake                 # 构建
xmake run             # 运行
```

构建产物在 `build/`，编译参数可在 `compile_commands.json` 中核对
（应指向 `/opt/homebrew/opt/llvm/bin/clang++`，含 `-std=c++26 -fmodule-file=std=std.pcm`）。
