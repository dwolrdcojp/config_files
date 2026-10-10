-- Programs
local terminal = "ghostty"
local menu = "wofi --show drun --matching fuzzy --allow-images --allow-markup"
local browser = "chromium" -- Native Wayland is set in ~/.config/chromium-flags.conf.
local mod = "SUPER"

-- Monitor: ASUS ROG Swift PG32UCDM, HDMI-A-1, 4K/240Hz, 150% scaling.
-- Monitor: 10-bit SDR sRGB, VRR only for fullscreen apps (avoids desktop OLED flicker).
hl.monitor({
	output = "HDMI-A-1",
	mode = "3840x2160@240.02",
	position = "0x0",
	scale = 1.5,
	bitdepth = 8,
	cm = "srgb",
	vrr = 2,
})
-- Environment
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("NVD_BACKEND", "direct") -- Optional: leave unset unless troubleshooting VA-API.
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("HYPRSHOT_DIR", "/home/max/screenshots")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Run once, when a new Hyprland session starts.
-- Your previous config opened two terminal windows; this preserves that behavior.
hl.on("hyprland.start", function()
	hl.exec_cmd(terminal)
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("dunst")
	hl.exec_cmd("wl-paste -t text --watch clipman store --no-persist")
	hl.exec_cmd(terminal, { workspace = "1 silent" })

	-- Previously disabled autostarts, left as examples:
	-- hl.exec_cmd("chromium", { workspace = "2 silent" })
	-- hl.exec_cmd("steam -silent", { workspace = "6 silent" })
	-- hl.exec_cmd("vesktop", { workspace = "8 silent" })
end)

-- Previously 'exec' (runs whenever configuration loads/reloads).
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

-- Core visual settings, input, layouts, cursor, and rendering
hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 20,
		border_size = 4,
		col = {
			active_border = {
				colors = { "rgba(679884ff)", "rgba(679884aa)" },
				angle = 45,
			},
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},

	decoration = {
		rounding = 25,
		active_opacity = 0.9,
		inactive_opacity = 0.5,
		fullscreen_opacity = 0.9,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = { enabled = true },
	dwindle = { preserve_split = true }, -- pseudotile option removed in Hyprland 0.56.
	master = {
		new_status = "slave",
		mfact = 0.5,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	input = {
		kb_layout = "us",
		kb_options = "caps:swapescape, altwin:swap_lalt_lwin",
		repeat_rate = 35,
		repeat_delay = 190,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = { natural_scroll = false },
	},
	cursor = {
		no_warps = false,
		hide_on_key_press = true,
	},
	xwayland = {
		force_zero_scaling = true, -- Keep Steam/XWayland sharper at 150% display scaling.
	},
	render = {
		direct_scanout = 0, -- Off, as in the original config.
	},
})

-- Bezier curves (converted from original 'bezier =' declarations)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations (same speeds, curves, and styles as the original config)
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- Main keybinds
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + I", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close({}))
hl.bind(mod .. " + M", hl.dsp.exit()) -- If using UWSM, prefer 'uwsm stop'.
hl.bind(mod .. " + R", hl.dsp.layout("swapnext"))
hl.bind(mod .. " + SHIFT + R", hl.dsp.layout("swapprev"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprshot -m region"))

-- Delay DPMS by one second, as in your old bind, using the Lua timer API.
hl.bind(mod .. " + Up", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "toggle" }))
	end, { timeout = 1000, type = "oneshot" })
end)

-- Pass your OBS recording shortcut through to OBS.
hl.bind(
	mod .. " + SHIFT + V",
	hl.dsp.pass({
		window = "class:^(com\\.obsproject\\.Studio)$",
	})
)

-- Focus/navigation in the Master layout
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mod .. " + J", hl.dsp.layout("cyclenext"))

-- Workspaces 1-10. Keys 1-9 map to workspace 1-9; key 0 maps to workspace 10.
for workspace = 1, 10 do
	local key = tostring(workspace % 10)
	local number = tostring(workspace)
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = number }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = number, follow = true }))
end

-- Special workspace (scratchpad)
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = true }))

-- Workspace scrolling
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse window move/resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio keys (allow on lock screen; hold to repeat volume changes)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Make selected applications fully opaque (preserves your override rules).
local opaque_apps = {
	"(steam)(.*)",
	"(chromium)(.*)",
	"(vlc)(.*)",
	"(spotify)(.*)",
	"(teams)(.*)",
	"(vesktop)(.*)",
}
for _, class_pattern in ipairs(opaque_apps) do
	hl.window_rule({
		match = { class = class_pattern },
		opacity = "1.0 override 1.0 override 1.0 override",
	})
end

-- Ignore application maximize requests.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- The original example 'epic-mouse-v1' device rule was omitted because it
-- references a fictional device. Add a real device rule if needed.
