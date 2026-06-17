# yazi: 退出时自动 cd 到浏览目录
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"   # 临时文件存 yazi 退出路径
    EDITOR=micro yazi "$@" --cwd-file="$tmp"       # 启动 yazi，退出写路径到 $tmp
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
