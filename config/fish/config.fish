if status is-interactive
    set -g fish_greeting ""
end

# ── shell integration ────────────────────────────────────────────────────
if test -f ~/.bash_aliases
    source ~/.bash_aliases
end

if type -q zoxide
    zoxide init fish | source
end

# ── editor / pager ───────────────────────────────────────────────────────
if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
else
    set -gx EDITOR vi
    set -gx VISUAL vi
end
set -gx PAGER less
set -gx LESS "-R"

# ── Athena OS / security tooling paths (preserved) ───────────────────────
set -x BFETCH_INFO "pfetch"
set -x BFETCH_ART "cowsay '<3 Athena OS'"
set -x BFETCH_COLOR "$HOME/.local/textart/color/icon/panes.textart"

set -x SECLISTS "/usr/share/seclists"
set -x PAYLOADSALLTHETHINGS "/usr/share/payloadsallthethings"
set -x FUZZDB "/usr/share/fuzzdb"

set -x MIMIKATZ "/usr/share/windows/mimikatz/"
set -x POWERSPLOIT "/usr/share/windows/powersploit/"

set -x ROCKYOU "$SECLISTS/Passwords/Leaked-Databases/rockyou.txt"
set -x DIRSMALL "$SECLISTS/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-small.txt"
set -x DIRMEDIUM "$SECLISTS/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
set -x DIRBIG "$SECLISTS/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-big.txt"
set -x WEBAPI_COMMON "$SECLISTS/Discovery/Web-Content/api/api-endpoints.txt"
set -x WEBAPI_MAZEN "$SECLISTS/Discovery/Web-Content/common-api-endpoints-mazen160.txt"
set -x WEBCOMMON "$SECLISTS/Discovery/Web-Content/common.txt"
set -x WEBPARAM "$SECLISTS/Discovery/Web-Content/burp-parameter-names.txt"

# ── quality of life ──────────────────────────────────────────────────────
alias ls 'ls --color=auto'
alias ll 'ls -lah --color=auto'
alias la 'ls -A --color=auto'
alias lt 'ls -lah --color=auto --sort=time'
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias df 'df -h'
alias free 'free -h'
alias ports 'ss -tulpn'
alias myip 'curl -s ifconfig.me; echo'
alias reload 'hyprctl reload'
alias cls 'clear'
alias .. 'cd ..'
alias ... 'cd ../..'

if type -q nvim
    alias vim nvim
end

# ── prompt ───────────────────────────────────────────────────────────────
if status is-interactive
    if not set -q NO_REPETITION
        fastfetch
    end
end
