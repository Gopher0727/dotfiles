#!/usr/bin/env bash
# 预编译 C++ 标准库模块 std.pcm，供 `import std;` 使用。
# 用法: build_std_pcm.sh [输出目录] [clang++ 路径]
#   - 输出目录: 默认当前目录，std.pcm 会写到这里
#   - clang++ 路径: 默认取 PATH 中的 clang++，务必与项目构建用的 clang 一致
#     （.pcm 与编译器版本及编译选项强绑定，不一致会报 module file config mismatch）
set -euo pipefail

OUT_DIR="${1:-.}"
CXX="${2:-$(command -v clang++)}"

if [[ -z "$CXX" || ! -x "$CXX" ]]; then
    echo "error: 找不到 clang++。请先安装 Homebrew LLVM: brew install llvm" >&2
    exit 1
fi

# 定位 libc++ 的模块源 std.cppm（Homebrew LLVM 装在 share/libc++/v1/ 下）
STD_CPPM=""
for cand in \
    "/opt/homebrew/opt/llvm/share/libc++/v1/std.cppm" \
    "$(dirname "$(dirname "$CXX")")/share/libc++/v1/std.cppm" \
    "/usr/local/share/libc++/v1/std.cppm" \
    "/usr/share/libc++/v1/std.cppm"; do
    if [[ -f "$cand" ]]; then
        STD_CPPM="$cand"
        break
    fi
done

if [[ -z "$STD_CPPM" ]]; then
    echo "error: 未找到 libc++ 模块源 std.cppm。Homebrew LLVM 通常位于 /opt/homebrew/opt/llvm/share/libc++/v1/std.cppm" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"
echo "==> 使用 $CXX"
echo "==> 预编译 $STD_CPPM -> $OUT_DIR/std.pcm"

# 优先 c++26（clang 19+ 的 cxxlatest）；老版本回退 c++23
if ! "$CXX" -std=c++26 \
        -Wno-reserved-module-identifier -Wno-reserved-user-defined-literal \
        --precompile -o "$OUT_DIR/std.pcm" "$STD_CPPM" 2>"$OUT_DIR/.std_pcm_build.log"; then
    rm -f "$OUT_DIR/std.pcm"
    "$CXX" -std=c++23 \
        -Wno-reserved-module-identifier -Wno-reserved-user-defined-literal \
        --precompile -o "$OUT_DIR/std.pcm" "$STD_CPPM" 2>"$OUT_DIR/.std_pcm_build.log"
fi
rm -f "$OUT_DIR/.std_pcm_build.log"

echo "==> 完成: $OUT_DIR/std.pcm ($(du -h "$OUT_DIR/std.pcm" | cut -f1))"
