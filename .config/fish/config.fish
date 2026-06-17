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
set -g fish_color_cancel FF0000 --reverse

## Commands & syntax
set -g fish_color_command 3051F2
set -g fish_color_comment 4D5A80
set -g fish_color_cwd 30F291
set -g fish_color_cwd_root FF0000
set -g fish_color_end FF0000

## Errors
set -g fish_color_error FF0000 --bold --background=550000

## Misc syntax
set -g fish_color_escape 4D5A80
set -g fish_color_history_current --bold
set -g fish_color_host A130F2
set -g fish_color_host_remote A130F2
set -g fish_color_keyword A130F2
set -g fish_color_normal FF0000
set -g fish_color_operator 30F291
set -g fish_color_param CC0000
set -g fish_color_quote F2D230
set -g fish_color_redirection FF0000 --bold

## Search / selection
set -g fish_color_search_match 30F291 --bold --background=342222
set -g fish_color_selection CC0000 --bold --background=0B292F

## Status / user
set -g fish_color_status FF0000
set -g fish_color_user CC0000
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

starship init fish | source
zoxide init fish | source

function fish_prompt
    set_color red
    printf '[%s@%s %s]$ ' $USER (hostname -s) (prompt_pwd)
    set_color normal
end
