# ~/.config/fish/conf.d/brew-env.fish

function switch_path
    set -l bin $argv[1]
    set -l cleaned
    for d in (string split : $PATH)
        if string match -rq "^$bin" "$d"
            continue
        end
        set -a cleaned $d
    end
    set -gx PATH $bin $cleaned
end

function jv
    set -l cur ($JAVA_HOME/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')
    set -l cm (echo $cur | cut -d. -f1)

    if test -z "$argv[1]"
        echo "Java versions:"
        echo "─────────────────────────────────────────────"

        set -l jh (brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
        set -l fv ($jh/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')
        set -l vm (echo $fv | cut -d. -f1)
        set -l m "○"; set -l c 2
        if test "$vm" = "$cm"; set m "●"; set c 32; end
        printf "  \e[%sm%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" $c $m "openjdk" $fv $jh

        set -l dirs
        for d in /opt/homebrew/opt/openjdk@*
            if test -L "$d"
                if test (readlink "$d") = (readlink (brew --prefix openjdk))
                    continue
                end
            end
            set -a dirs (basename $d | string replace "openjdk@" "")
        end
        for v in (printf "%s\n" $dirs | sort -nr)
            set -l jh "/opt/homebrew/opt/openjdk@$v/libexec/openjdk.jdk/Contents/Home"
            test -d "$jh"; or continue
            set -l fv ($jh/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}')
            set -l vm (echo $fv | cut -d. -f1)
            set -l m "○"; set -l c 2
            if test "$vm" = "$cm"; set m "●"; set c 32; end
            printf "  \e[%sm%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" $c $m "openjdk@$v" $fv $jh
        end

        echo "─────────────────────────────────────────────"
        echo "Usage: jv <version>  switch java version"
        echo "  e.g. jv 21"
        return
    end

    set -l jh "/opt/homebrew/opt/openjdk@$argv[1]/libexec/openjdk.jdk/Contents/Home"
    if not test -d "$jh"
        echo "Error: Java $argv[1] not found"
        return 1
    end
    set -gx JAVA_HOME $jh
    switch_path "$jh/bin"
    echo "Switched to Java $argv[1] ($($jh/bin/java -version 2>&1 | head -1 | awk -F'"' '{print $2}'))"
end

function pv
    set -l cur (python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)

    if test -z "$argv[1]"
        echo "Python versions:"
        echo "─────────────────────────────────────────────"

        set -l dirs
        for d in /opt/homebrew/opt/python@*
            test -d "$d"; or continue
            set -l v (basename $d | string replace "python@" "")
            test "$v" = "3"; and continue
            set -a dirs $v
        end

        for v in (printf "%s\n" $dirs | sort -t. -k1,1n -k2,2nr)
            set -l fv (/opt/homebrew/opt/python@$v/bin/python$v --version 2>&1 | awk '{print $2}')
            set -l m "○"; set -l c 2
            if test (echo $fv | cut -d. -f1,2) = $cur
                set m "●"; set c 32
            end
            printf "  \e[%sm%s %-12s %-7s\e[0m  \e[90m%s\e[0m\n" $c $m "python@$v" $fv /opt/homebrew/opt/python@$v/bin
        end

        echo "─────────────────────────────────────────────"
        echo "Usage: pv <version>  switch python version"
        echo "  e.g. pv 3.11"
        return
    end

    set -l lh "/opt/homebrew/opt/python@$argv[1]/libexec/bin"
    if not test -d "$lh"
        echo "Error: Python $argv[1] not found"
        return 1
    end
    switch_path $lh
    echo "Switched to Python $argv[1] ($(python3 --version 2>&1 | awk '{print $2}'))"
end
