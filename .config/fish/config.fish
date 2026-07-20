source /usr/share/cachyos-fish-config/cachyos-config.fish
export BROWSER=firefox
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
set -x QT_QPA_PLATFORMTHEME qt5ct
set -x QT_QPA_PLATFORMTHEME qt6ct
set -x QT_QPA_PLATFORMTHEME qtct
set -Ux fish_user_paths ~/.npm-global/bin $fish_user_paths
# alias ls=eza

# ---------------------------------------
# cybr-fish   lucid theme for fish
# Project:    https://github.com/cybrcore/cybr-fish
# Author:     scherrer-txt   |   License:     GPL-3.0
# Source:     ~/.config/fish/config.fish
# ---------------------------------------

# Environment
set -gx EDITOR micro
set -gx VISUAL visual-studio-code-git
set -gx STARSHIP_CONFIG ~/.config/starship.toml

set -gx TERM xterm-kitty
set -gx COLORTERM truecolor
set -gx MICRO_TRUECOLOR 1

# Theme
## Autosuggestion
set -g fish_color_autosuggestion 4D5A80

## Cancel
set -g fish_color_cancel 22C55E --reverse

## Commands & syntax
set -g fish_color_command 3051F2
set -g fish_color_comment 4D5A80
set -g fish_color_cwd 22C55E
set -g fish_color_cwd_root 22C55E
set -g fish_color_end 22C55E

## Errors
set -g fish_color_error 22C55E --bold --background=2B2D31

## Misc syntax
set -g fish_color_escape 4D5A80
set -g fish_color_history_current --bold
set -g fish_color_host A130F2
set -g fish_color_host_remote A130F2
set -g fish_color_keyword A130F2
set -g fish_color_normal 22C55E
set -g fish_color_operator 22C55E
set -g fish_color_param 1A9E4A
set -g fish_color_quote F2D230
set -g fish_color_redirection 22C55E --bold

## Search / selection
set -g fish_color_search_match 22C55E --bold --background=1A1B1E
set -g fish_color_selection 1A9E4A --bold --background=1A1B1E

## Status / user
set -g fish_color_status 22C55E
set -g fish_color_user 1A9E4A
set -g fish_color_valid_path --underline

## Pager
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow -i
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_selected_background -r

## Key bindings
set -U fish_key_bindings fish_default_key_bindings

# Optional flatpak caching
if not set -q FLATPAK_PATHS
    set -gx FLATPAK_PATHS (flatpak --installations)
end

# starship init fish | source
zoxide init fish | source

function fish_prompt
    set_color green
    printf '[%s@%s %s]$ ' $USER (hostname -s) (prompt_pwd)
    set_color normal
end
	# starship init fish | source
