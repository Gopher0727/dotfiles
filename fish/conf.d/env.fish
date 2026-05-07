# ~/.config/fish/conf.d/env.fish
set -gx JAVA_HOME (brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home
set -gx PATH $JAVA_HOME/bin $PATH
set -gx PATH /opt/dev $PATH
set -gx PATH /usr/local/texlive/2026/bin/universal-darwin $PATH
