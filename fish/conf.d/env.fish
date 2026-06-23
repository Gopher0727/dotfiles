# ~/.config/fish/conf.d/env.fish

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# PATH
set -gx PATH /opt/dev $PATH
set -gx PATH /usr/local/texlive/2026/bin/universal-darwin $PATH
set -gx PATH $HOME/go/bin $PATH

# Java
set -gx JAVA_HOME (brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
set -gx PATH $JAVA_HOME/bin $PATH

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH