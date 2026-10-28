function fish_prompt
    set -l last_status $status
    set -l red (set_color c1121f)
    set -l red_hi (set_color e53946)
    set -l dim (set_color 8b8b96)
    set -l fg (set_color d7d7de)
    set -l err (set_color e53946)

    set -l user (whoami)
    set -l host (prompt_hostname)
    set -l path (prompt_pwd)
    set -l branch

    if type -q git
        set branch (git symbolic-ref --short HEAD 2>/dev/null)
    end

    echo -n "$red╭─[$red_hi$user$dim@$red_hi$host$red]─[$fg$path$red]"
    if test -n "$branch"
        echo -n "[$dim$branch$red]"
    end
    echo

    if test $last_status -ne 0
        echo -n "$red╰─[$err$last_status$red]› "
    else
        echo -n "$red╰─$red_hi› "
    end

    set_color normal
end

function fish_right_prompt
    set -l dim (set_color 5a5a66)
    echo -n "$dim"(date +%H:%M)" "(set_color normal)
end
