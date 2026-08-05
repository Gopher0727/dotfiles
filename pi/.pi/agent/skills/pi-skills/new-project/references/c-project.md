# C 项目模板（xmake.lua）

纯 C 项目使用最简模板，不指定语言标准和工具链（系统默认即可）。

```lua
add_rules("mode.debug", "mode.release")

target("<project-name>")
    set_kind("binary")
    add_files("src/*.c")
```

源码示例 `src/main.c`：

```c
#include <stdio.h>

int main(void) {
    printf("Hello from <project-name>!\n");
    return 0;
}
```
