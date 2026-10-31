-- ============================================================================
--  Zazzu :: Hyprland 0.56+ Lua configuration
--  Dark red on black · dwm-style master layout · VM friendly (no blur/shadows)
--  Editor support: .luarc.json points LuaLS at /usr/share/hypr/stubs
-- ============================================================================

local home = os.getenv("HOME")
local scripts = home .. "/.config/hypr/scripts"
local wall = home .. "/.config/hypr/wallpapers/zazzu-dark-red.png"

-- Palette (keep in sync with waybar/style.css, dunstrc, kitty, etc.)
local col = {
	bg = "rgba(08080aff)",
	surface = "rgba(0f0f12ff)",
	border = "rgba(2a2a31ff)",
	red = "rgba(c1121fff)",
	red_soft = "rgba(7f0d17ff)",
	red_hi = "rgba(e53946ff)",
	fg = "rgba(d7d7deff)",
}

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-2",
	mode = "1920x1080@180",
	position = "auto",
	scale = 1,
})

---------------------
---- ENVIRONMENT ----
---------------------

-- VMware guests: pin Aquamarine to the SVGA adapter. On bare metal we leave
-- device selection to Aquamarine, which handles hybrid laptops correctly.
local function on_vmware()
	local f = io.open("/sys/class/dmi/id/sys_vendor", "r")
	if not f then
		return false
	end
	local vendor = f:read("l") or ""
	f:close()
	return vendor:find("VMware") ~= nil
end

if on_vmware() then
	hl.env("AQ_DRM_DEVICES", "/dev/dri/card0")
end

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "Fusion")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,
		border_size = 2,
		layout = "master",
		resize_on_border = true,
		allow_tearing = false,
		col = {
			active_border = col.red,
			inactive_border = col.border,
			nogroup_border = col.border,
		},
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		dim_inactive = false,
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = false,
	},

	master = {
		mfact = 0.55,
		new_status = "master",
		new_on_top = true,
		orientation = "left",
		special_scale_factor = 0.90,
		smart_resizing = true,
		focus_master_on_close = true,
		allow_small_split = false,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		background_color = "0x08080aff",
		focus_on_activate = true,
		mouse_move_focuses_monitor = true,
		middle_click_paste = true,
		disable_scale_notification = true,
		font_family = "JetBrainsMono Nerd Font",
		splash_font_family = "JetBrainsMono Nerd Font",
	},

	input = {
		kb_layout = "us,ara",
		kb_variant = "",
		follow_mouse = 1,
		sensitivity = 0,
		numlock_by_default = true,
		repeat_rate = 40,
		repeat_delay = 250,
		kb_options = "grp:alt_shift_toggle",
		touchpad = {
			natural_scroll = false,
			disable_while_typing = true,
			tap_to_click = true,
		},
	},

	binds = {
		workspace_back_and_forth = true,
		allow_workspace_cycles = true,
		window_direction_monitor_fallback = true,
		hide_special_on_workspace_change = false,
	},

	cursor = {
		no_hardware_cursors = true, -- VMware / llvmpipe
		enable_hyprcursor = false,
		sync_gsettings_theme = true,
		inactive_timeout = 8,
	},

	xwayland = {
		enabled = true,
		force_zero_scaling = false,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	render = {
		direct_scanout = 0,
	},
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")
	hl.exec_cmd("dunst")
	hl.exec_cmd("hypridle")

	-- Clipboard history (text + images)
	hl.exec_cmd("wl-paste --type text  --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	-- Desktop integration
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("udiskie --no-notify --tray")

	-- Wallpaper (hyprpaper may need a moment to come up)
	hl.exec_cmd("sleep 0.4; hyprctl hyprpaper wallpaper '," .. wall .. "'")
end)

---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER"

-- Core applications -----------------------------------------------------------
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("discord"))
hl.bind(mod .. " + ALT + Return", hl.dsp.exec_cmd("kitty --class floating-term"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("brave"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun --prompt ' run '"))
-- hl.bind(mod .. " + SHIFT + R",     hl.dsp.exec_cmd("wofi --show run --prompt ' exec '"))
-- hl.bind(mod .. " + SHIFT + W",     hl.dsp.exec_cmd(scripts .. "/wallpaper.sh"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd(scripts .. "/clipboard.sh"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("pavucontrol"))

-- Window management -----------------------------------------------------------
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd(scripts .. "/power-menu.sh"))
-- hl.bind(mod .. " + F",             hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
-- hl.bind(mod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mod .. " + P",             hl.dsp.window.pseudo())
-- hl.bind(mod .. " + SHIFT + P",     hl.dsp.window.pin())
hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

-- Focus -----------------------------------------------------------------------
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Master layout (dwm-like) ----------------------------------------------------
hl.bind(mod .. " + ALT + M", hl.dsp.layout("swapwithmaster auto"))
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mod .. " + comma", hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + period", hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + i", hl.dsp.layout("addmaster"))
hl.bind(mod .. " + d", hl.dsp.layout("removemaster"))
hl.bind(mod .. " + grave", hl.dsp.layout("focusmaster"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.layout("swapwithmaster master"))
hl.bind(mod .. " + SHIFT + O", hl.dsp.layout("orientationnext"))
hl.bind(mod .. " + SHIFT + I", hl.dsp.layout("orientationprev"))

-- Move windows with mod + SHIFT + arrows --------------------------------------
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Workspaces ------------------------------------------------------------------
-- Hyprland numbers workspaces globally, so each output owns its own block of
-- ten ids (see ws_blocks below). Waybar relabels every block back to 1-10 (see
-- waybar/config.jsonc), so both bars look identical while SUPER+1..0 always
-- targets the monitor that has focus.
local ws_per_output = 10
local ws_blocks = { -- first workspace id of each output
	["eDP-1"] = 1,
	["HDMI-A-2"] = 11,
}

-- Base workspace id (0 for the 1-10 block) of an output.
local function output_base(name)
	local first = ws_blocks[name]
	if first then
		return first - 1
	end

	-- Output not listed above yet: hand out the first block nobody uses.
	local used = {}
	for _, monitor in ipairs(hl.get_monitors()) do
		local known = ws_blocks[monitor.name]
		if known then
			used[known - 1] = true
		end
	end
	local base = 0
	while used[base] do
		base = base + ws_per_output
	end
	return base
end

-- Workspace id for slot 1-10 on the focused monitor.
local function workspace_id(slot)
	local monitor = hl.get_active_monitor()
	return (monitor and output_base(monitor.name) or 0) + slot
end

for slot = 1, ws_per_output do
	local key = slot % 10
	hl.bind(mod .. " + " .. key, function()
		hl.dispatch(hl.dsp.focus({ workspace = workspace_id(slot) }))
	end)
	hl.bind(mod .. " + SHIFT + " .. key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = workspace_id(slot) }))
	end)
end

-- Cycle through the focused monitor's own ten workspaces.
local function cycle_workspace(step)
	local monitor = hl.get_active_monitor()
	local workspace = hl.get_active_workspace()
	if not monitor or not workspace then
		return
	end

	local base = output_base(monitor.name)
	local slot = workspace.id - base
	if slot < 1 or slot > ws_per_output then
		slot = 1
	end
	slot = ((slot - 1 + step) % ws_per_output) + 1

	hl.dispatch(hl.dsp.focus({ workspace = base + slot }))
end

-- hl.bind(mod .. " + SHIFT + S",     hl.dsp.window.move({ workspace = "special:scratch" }))
-- hl.bind(mod .. " + S",             hl.dsp.workspace.toggle_special("scratch"))
hl.bind(mod .. " + mouse_down", function()
	cycle_workspace(1)
end)
hl.bind(mod .. " + mouse_up", function()
	cycle_workspace(-1)
end)

-- Mouse -----------------------------------------------------------------------
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots -----------------------------------------------------------------
hl.bind(mod .. "+ SHIFT + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(scripts .. "/screenshot.sh window"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd(scripts .. "/screenshot.sh swappy"))

-- Media / hardware keys -------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scripts .. "/volume.sh up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scripts .. "/volume.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "/volume.sh mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scripts .. "/volume.sh mic"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scripts .. "/brightness.sh up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scripts .. "/brightness.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Lock / session --------------------------------------------------------------
hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + ALT + Escape", hl.dsp.exec_cmd("loginctl lock-session"))

-- Reload / misc ---------------------------------------------------------------
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + M", function()
	hl.dispatch(hl.dsp.exit())
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Floating utilities ----------------------------------------------------------
hl.window_rule({
	name = "float-utilities",
	match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor|org\\.gnome\\.Calculator|galculator)$" },
	float = true,
	size = "900 600",
	center = true,
})

hl.window_rule({
	name = "float-floating-term",
	match = { class = "floating-term" },
	float = true,
	size = "980 620",
	center = true,
})

hl.window_rule({
	name = "float-file-pickers",
	match = { title = "^(Open File|Open Folder|Save File|Choose Files?)$" },
	float = true,
	size = "900 620",
	center = true,
})

-- Picture in picture ----------------------------------------------------------
hl.window_rule({
	name = "pip",
	match = { title = "^(Picture-in-Picture|Picture in picture)$" },
	float = true,
	pin = true,
	size = "480 270",
	move = "100% 100%",
})

-- XWayland drag fix -----------------------------------------------------------
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Suppress maximize requests so master layout stays predictable ---------------
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Workspaces ------------------------------------------------------------------
hl.workspace_rule({
	workspace = "special:scratch",
	gaps_out = 6,
	gaps_in = 3,
})

-- Pin every output's block of ten workspaces to that output, so a workspace
-- is always (re)created on the side it belongs to.
for output, first in pairs(ws_blocks) do
	for slot = 0, ws_per_output - 1 do
		hl.workspace_rule({ workspace = tostring(first + slot), monitor = output })
	end
end

-- Open the analyser stack on workspace 1 and comms on 2 -----------------------
hl.workspace_rule({ workspace = "1", default_name = "main" })
hl.workspace_rule({ workspace = "2", default_name = "web" })
hl.workspace_rule({ workspace = "3", default_name = "lab" })
hl.workspace_rule({ workspace = "4", default_name = "notes" })
hl.workspace_rule({ workspace = "5", default_name = "media" })
