# dotfiles :: zazzu

Dark-red-on-black Hyprland workstation, built for an Athena OS / Arch box used
for malware analysis. dwm-style master layout, flat 28px Waybar, no animations
or blur (VM / llvmpipe friendly), with XFCE kept as a fallback session.

```
palette   #08080a  bg          #c1121f  red        #d7d7de  fg
          #0f0f12  surface     #e53946  red-hi     #8b8b96  dim
          #2a2a31  border      #7f0d17  red-soft
```

## What is in here

```
install.sh                  main installer (packages, configs, theme, SDDM)
packages/pacman.txt         official repo packages
packages/aur.txt            AUR / chaotic-aur packages
scripts/install-yay.sh      bootstraps yay
scripts/build-theme.py      regenerates theme/Zazzu-Red from Matrix-Dark
scripts/generate-wallpaper.py  regenerates the 4K wallpaper
config/hypr/                Hyprland 0.56 Lua config, lock/idle/paper, scripts
config/waybar/              dwm-style bar
config/wofi/                launcher
config/dunst/               notifications
config/kitty/ alacritty/    terminals
config/btop/ fastfetch/     system views
config/fish/                shell config + prompt
config/nvim/                Neovim: zazzu colorscheme, flat statusline, LSP
config/gtk-3.0 gtk-4.0      GTK settings + libadwaita accent overrides
config/qt5ct qt6ct          Qt colours (templates rendered at install)
config/gtk-2.0/gtkrc-2.0    legacy GTK2 apps
theme/Zazzu-Red             complete GTK2/3/4 theme (black + red)
sddm/                       dark-red variant of sddm-astronaut-theme
patches/                    opt-in fixes for specific environments (VMware)
```

## Install

```bash
git clone https://github.com/krypton-0x00/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` will:

1. Install missing packages from `packages/*.txt` (bootstrapping `yay` if needed).
2. Back up anything it replaces to `~/.dotfiles-backup-<timestamp>/`.
3. Symlink config trees into `~/.config` and put `Zazzu-Red` in `~/.themes`.
4. Render the Qt5ct/Qt6ct templates, apply GTK/icon/cursor settings, recolour
   Papirus folders red.
5. Install the user-level Neovim tooling (pyright, tree-sitter, stylua, ruff)
   plus the treesitter parsers under `~/.local` and `~/.local/share/nvim`.
6. Add the dark-red SDDM variant and preselect Hyprland (XFCE stays selectable).

Flags: `--no-packages` / `--config-only`, `--no-sddm`, `--keep-session`, `--help`.

Requirements: Arch-based distro, `sddm-astronaut-theme` for the login screen
(optional packages are listed in `packages/optional.txt`), and
`matrix-gtk-theme` only if you want to rebuild the GTK theme.

> The sudo password is never stored in this repo. The installer uses the normal
> sudo prompt; only `yay`/`makepkg` may ask again while building AUR packages.

## Daily keys

| Key | Action |
| --- | --- |
| `SUPER+Return` | kitty |
| `SUPER+ALT+Return` | floating kitty |
| `SUPER+B` / `SUPER+E` | Firefox / Thunar |
| `SUPER+R` / `SUPER+SHIFT+R` | app launcher / command launcher |
| `SUPER+V` / `SUPER+SHIFT+V` | clipboard history / audio mixer |
| `SUPER+Q` | close window |
| `SUPER+SHIFT+Q` | power menu |
| `SUPER+F` / `SUPER+SHIFT+F` | fullscreen / maximise |
| `SUPER+Space` | toggle floating |
| `SUPER+Tab` / `SUPER+SHIFT+Tab` | next / previous window |
| `SUPER+arrows` or `SUPER+hjkl` | focus |
| `SUPER+SHIFT+arrows` or `SUPER+SHIFT+hjkl` | swap window |
| `SUPER+grave` / `SUPER+SHIFT+grave` | focus / swap with master |
| `SUPER+,` / `SUPER+.` | shrink / grow master |
| `SUPER+I` / `SUPER+D` | add / remove master |
| `SUPER+ALT+M` | swap with master (auto) |
| `SUPER+SHIFT+O/I` | next / previous orientation |
| `SUPER+1..0` / `SUPER+SHIFT+1..0` | go to / move window to workspace 1–10 on the focused monitor |
| `SUPER+S` / `SUPER+SHIFT+S` | scratchpad / send to scratchpad |
| `SUPER+SHIFT+W` | wallpaper picker |
| `SUPER+mouse wheel` | cycle the focused monitor's workspaces |
| `Print` | region screenshot (copy + save) |
| `SHIFT+Print` | full screenshot |
| `SUPER+Print` / `SUPER+SHIFT+Print` | window / swappy annotate |
| `SUPER+ALT+L` | lock |
| `SUPER+SHIFT+C` / `SUPER+SHIFT+M` | reload config / exit Hyprland |

Volume, mic mute, brightness, play/pause and media keys are bound too.

## Layout model

Hyprland runs the `master` layout with `new_on_top = true`, `mfact = 0.55`,
`orientation = left` and `focus_master_on_close = true`. That is the closest
behaviour to dwm's tile stack while still allowing manual resizing with
`SUPER` + right-drag.

### Workspaces

Every monitor gets its own ten workspaces, and both bars always read `1`–`10`.
Hyprland numbers workspaces globally, so each output owns a block of ids
(`eDP-1` → 1–10, `HDMI-A-2` → 11–20; see `ws_blocks` in `hyprland.lua`) and
Waybar relabels the block back to 1–10 on that output's bar. `SUPER+1..0`
resolves against the monitor that currently has focus, so the same keys always
drive the bar you are looking at.

Workspaces 1–5 also keep the names `main`, `web`, `lab`, `notes`, `media`.
The special workspace `scratch` is the scratchpad.

Adding a monitor: give it the next free ten ids in `ws_blocks` (in
`config/hypr/hyprland.lua`) and the matching `persistent-workspaces` entry plus
`format-icons` relabeling (in `config/waybar/config.jsonc`).

## Editor

`config/nvim` is a small, self-contained Neovim config (lazy.nvim, ~10 plugins)
themed with the same palette as the bar: `zazzu` colorscheme, flat dwm-style
statusline, no icons in the UI chrome. It is symlinked to `~/.config/nvim` by
`install.sh`.

Out of the box it speaks **Rust, C, C++ and Python**:

| Language | LSP | Format on save | Parser |
| --- | --- | --- | --- |
| Rust | `rust-analyzer` | `rustfmt` | `rust` |
| C / C++ | `clangd` | `clang-format` | `c`, `cpp` |
| Python | `pyright` | `ruff` (or `black`) | `python` |
| Lua (config) | – | `stylua` | `lua` |

The system half comes from pacman (`rustup`, `clang`, `python`, `nodejs`);
`pyright`, `tree-sitter`, `stylua` and `ruff` are installed per-user into
`~/.local/bin` by `install.sh`, so nothing needs root. Servers that are missing
are skipped with a notification instead of breaking startup, and autosave
formatting only runs for Python when a formatter is actually present.

Keys (leader is `Space`):

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fg` | find files / grep project (telescope) |
| `<leader>fb` / `<leader>fh` / `<leader>fd` | buffers / help tags / diagnostics |
| `<leader>e` / `<leader>o` | toggle / focus the file tree |
| `gd` `gD` `gi` `gt` `gr` | LSP jump to definition / declaration / impl / type / refs |
| `K` | hover documentation |
| `<leader>rn` / `<leader>ca` | rename / code action |
| `[d` / `]d` | previous / next diagnostic |
| `<leader>fm` | format buffer |
| `]c` / `[c` | next / previous git hunk |
| `<leader>gs` / `<leader>gr` / `<leader>gp` | stage / reset / preview hunk |
| `<leader>tt` / `<leader>tv` | terminal split / vsplit |

`:checkhealth vim.lsp` and `:checkhealth nvim-treesitter` show what is wired up.

## Regenerating art

```bash
python3 scripts/generate-wallpaper.py   # -> config/hypr/wallpapers/zazzu-dark-red.png
python3 scripts/build-theme.py          # -> theme/Zazzu-Red
```

`build-theme.py` recolours the entire Matrix-Dark GTK3/GTK4 stylesheets and
GTK2 assets in place in `theme/Zazzu-Red`; tweak the palette at the top of the
script and re-run.

## Notes / troubleshooting

- **Hyprland 0.56+ uses Lua.** The config is `~/.config/hypr/hyprland.lua`.
  Do not add `hyprland.conf`; if one exists, Lua wins at startup but keeping
  both around is confusing. Validate with:
  `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`.
- **SDDM upgrades** reset `metadata.desktop`. Re-run
  `sudo ~/dotfiles/sddm/install-sddm.sh` after upgrading the theme package.
- **VM performance**: animations, blur, shadows and hardware cursors are off.
  If Hyprland feels slow, check that `misc:vfr` is on and avoid 4K outputs.
- **VMware 3D acceleration**: this VM now has 3D enabled, so Hyprland uses
  the `vmwgfx`/`SVGA3D` driver (GLES 3.1). If 3D acceleration is disabled
  again, Mesa's explicit EGL device init fails with `DRI2: failed to create
  screen` and Hyprland aborts in `CBackend::create()`. In that case add
  `hl.env("MESA_LOADER_DRIVER_OVERRIDE", "kms_swrast")` to `hyprland.lua` to
  fall back to llvmpipe; GBM/dmabuf scanout keeps working.
- **VMware + GPU terminals crash** (`wl_surface.attach: invalid arguments`,
  kitty/alacritty `SIGSEGV`, `drmCloseBufferHandle failed` in the log):
  `vmwgfx` hands Hyprland TTM surface handles that `drmCloseBufferHandle()`
  cannot release, so Hyprland rejects every DMA-BUF from GPU clients.
  Stock Hyprland is broken in this VM; build the patched one with
  `patches/vmware-hyprland-dmabuf/apply.sh`. Bare-metal installs do not need
  it. Only `AQ_DRM_DEVICES` is VM-specific in `hyprland.lua`, and it is set
  only when DMI reports VMware, so the config stays portable.
- **Waybar** starts from Hyprland's autostart; reload it with
  `pkill waybar; waybar &` or just `SUPER+SHIFT+C`.
- **Qt apps**: `QT_QPA_PLATFORMTHEME=qt6ct` is set in `hyprland.lua`. Qt5-only
  apps can be launched with `QT_QPA_PLATFORMTHEME=qt5ct <app>` (both configs are
  installed and themed).
- **Wallpaper picker**: `SUPER+SHIFT+W`, picks from `config/hypr/wallpapers`
  and `~/Pictures`.
- **Clipboard**: `cliphist` + `wl-clip-persist` start with the session; history
  survives until you clear it with `cliphist wipe`.

## Restoring the old setup

Every replaced file lives under `~/.dotfiles-backup-<timestamp>/`, mirroring its
original path. Move things back from there, or delete the symlinks and restore
the backup directory.

---

Built for `zazzu` on Athena OS. XFCE remains installed and selectable at the
login screen as a fallback.
