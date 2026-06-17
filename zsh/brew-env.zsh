# 扫描 /opt/homebrew/opt/<prefix>@* 目录，提取版本号
function scan_versions() {
    local pattern="$1" trim="$2"     # glob 模式 & 要去掉的前缀
    for d in $~pattern(N); do        # (N) 允许无匹配时不报错
        [[ -d "$d" ]] || continue
        basename "$d" | sed "s/$trim//"
    done
}

# 替换 PATH 中匹配的旧路径为新路径
function switch_path() {
    local bin="$1" cleaned=""        # 新的 bin 目录
    for d in ${(s.:.)PATH}; do       # 按 : 分割 PATH
        [[ "$d" == $bin* ]] && continue   # 跳过相同前缀的旧版本
        cleaned="${cleaned}:${d}"
    done
    export PATH="${bin}${cleaned}"   # 新路径放在最前面
}

# 生成 java17 / java21 / java25 ... 快捷函数（自动扫描已装版本）
for v in $(scan_versions "/opt/homebrew/opt/openjdk@*" "openjdk@"); do
    local jh="/opt/homebrew/opt/openjdk@${v}/libexec/openjdk.jdk/Contents/Home"
    eval "java${v}() { ${jh}/bin/java \"\$@\" }"
done

function jv() {
    # 从当前 JAVA_HOME 获取当前主版本号 (17/21/25/26)
    local cur=$($JAVA_HOME/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')

    if [[ -z "$1" ]]; then
        echo "Java versions:"
        echo "─────────────────────────────────────────────"

        # 主 openjdk（brew 管理的最新版，始终在最上面）
        local jh="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
        local fv=$(${jh}/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')
        local vm=$(echo "$fv" | cut -d. -f1) cm=$(echo "$cur" | cut -d. -f1)
        local m="○" c="2"; [[ "$vm" == "$cm" ]] && { m="●"; c="32"; }
        printf "  \e[${c}m%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" "$m" "openjdk" "$fv" "$jh"

        # 已安装的指定版本（降序）
        for v in $(scan_versions "/opt/homebrew/opt/openjdk@*" "openjdk@" | sort -Vr); do
            local dir="/opt/homebrew/opt/openjdk@${v}"
            # 跳过主 openjdk 的别名
            [[ "$(readlink "$dir")" == "$(readlink /opt/homebrew/opt/openjdk)" ]] && continue
            local jh="${dir}/libexec/openjdk.jdk/Contents/Home"
            [[ -d "$jh" ]] || continue
            local fv=$(${jh}/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')
            local vm=$(echo "$fv" | cut -d. -f1)
            local m="○" c="2"
            [[ "$vm" == "$cm" ]] && { m="●"; c="32"; }
            printf "  \e[${c}m%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" "$m" "openjdk@${v}" "$fv" "$jh"
        done
        echo "─────────────────────────────────────────────"
        echo "Usage: jv <version>  switch java version"
        echo "  e.g. jv 21"
        return
    fi

    # 切换到指定版本
    local jh="/opt/homebrew/opt/openjdk@${1}/libexec/openjdk.jdk/Contents/Home"
    [[ -d "$jh" ]] || { echo "Error: Java ${1} not found"; return 1; }
    export JAVA_HOME="$jh"
    switch_path "${jh}/bin"
    echo "Switched to Java ${1} ($(${jh}/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}'))"
}

# 生成 python39 / python310 ... 和 pip39 / pip310 ... 快捷函数
for v in $(scan_versions "/opt/homebrew/opt/python@*" "python@"); do
    [[ "$v" == "3" ]] && continue                    # 跳过 python@3 别名
    local ph="/opt/homebrew/opt/python@${v}/bin"
    local bn="python${v}" vn=$(echo "$v" | tr -d .)  # bn=python3.11  vn=311
    eval "python${vn}() { ${ph}/${bn} \"\$@\" }
          pip${vn}() { ${ph}/pip3 \"\$@\" }"
done

function pv() {
    # 获取当前 Python 的 major.minor 版本号 (如 3.14)
    local cur=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)

    if [[ -z "$1" ]]; then
        echo "Python versions:"
        echo "─────────────────────────────────────────────"
        for v in $(scan_versions "/opt/homebrew/opt/python@*" "python@" | sort -Vr); do
            [[ "$v" == "3" ]] && continue
            local lh="/opt/homebrew/opt/python@${v}/libexec/bin"
            [[ -d "$lh" ]] || continue
            local fv=$(python${v} --version 2>&1 | awk '{print $2}')
            local m="○" c="2"                            # 默认灰 ○
            [[ "$(echo "$fv" | cut -d. -f1,2)" == "$cur" ]] && { m="●"; c="32"; }   # 当前绿色 ●
            printf "  \e[${c}m%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" "$m" "python@${v}" "$fv" "$lh"
        done
        echo "─────────────────────────────────────────────"
        echo "Usage: pv <version>  switch python version"
        echo "  e.g. pv 3.11"
        return
    fi

    # 切换到指定版本
    local lh="/opt/homebrew/opt/python@${1}/libexec/bin"
    [[ -d "$lh" ]] || { echo "Error: Python ${1} not found"; return 1; }
    switch_path "$lh"
    echo "Switched to Python ${1} ($(python3 --version 2>&1 | awk '{print $2}'))"
}
