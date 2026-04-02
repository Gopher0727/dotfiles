if status is-interactive
# Commands to run in interactive sessions can go here
end

# 别名
alias l="command ls"
alias ls="lsd -l"

# Go
fish_add_path /usr/local/go/bin
fish_add_path $HOME/go/bin

# Cargo
fish_add_path $HOME/.cargo/bin

# Flutter
fish_add_path $HOME/dev/flutter/bin

# Android SDK & Java
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
fish_add_path $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
fish_add_path $ANDROID_SDK_ROOT/platform-tools

if not set -q JAVA_HOME; or test -z "$JAVA_HOME"
    echo "JAVA_HOME is null"
    echo "   TODO: set -Ux JAVA_HOME /path/to/your/java"
else
    fish_add_path $JAVA_HOME/bin
end

# zoxide
zoxide init fish | source

# starship
starship init fish | source
 
