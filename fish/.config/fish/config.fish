if status is-interactive
# Commands to run in interactive sessions can go here
end

# 别名
alias l="command ls"
alias ls="lsd -l"

# Go 环境
set -Ux PATH /usr/local/go/bin $PATH
set -gx PATH $HOME/go/bin $PATH

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH

# Flutter
set -gx PATH $HOME/dev/flutter/bin $PATH

# Android SDK & Java
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
set -gx PATH $ANDROID_SDK_ROOT/cmdline-tools/latest/bin $PATH
set -gx PATH $ANDROID_SDK_ROOT/platform-tools $PATH
set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk
set -gx PATH $JAVA_HOME/bin $PATH

# zoxide
zoxide init fish | source

