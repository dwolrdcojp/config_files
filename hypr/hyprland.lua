-- Programs
local terminal = "ghostty"
local menu = "wofi --show drun --matching fuzzy --allow-images --allow-markup"
local browser = "chromium" -- Native Wayland is set in ~/.config/chromium-flags.conf.
local mod = "SUPER"

-- Monitor: ASUS ROG Swift PG32UCDM, HDMI-A-1, 4K/120Hz, 150% scaling, VRR disabled
hl.monitor {
  output = "HDMI-A-1",
  mode = "3840x2160@119.88",
  position = "0x0",
  scale = 1.5,
  bitdepth = 8,
  cm = "srgb",
  vrr = 0,
}

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

-- Session startup
hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("dunst")
  hl.exec_cmd("wl-paste -t text --watch clipman store --no-persist")
  hl.exec_cmd(terminal, { workspace = "1 silent" }) -- Open a second terminal on workspace 1.

  -- Optional autostarts:
  -- hl.exec_cmd("chromium", { workspace = "2 silent" })
  -- hl.exec_cmd("steam -silent", { workspace = "6 silent" })
  -- hl.exec_cmd("vesktop", { workspace = "8 silent" })
end)

-- Run whenever the configuration loads or reloads.
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')

-- Settings
hl.config {
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

  dwindle = { preserve_split = true },

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
    direct_scanout = 0,
  },
}

-- Bezier curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
local function animation(name, speed, curve, style)
  hl.animation {
    leaf = name,
    enabled = true,
    speed = speed,
    bezier = curve,
    style = style,
  }
end

-- Name, speed, curve, optional style
animation("global", 10, "default")
animation("border", 5.39, "easeOutQuint")

animation("windows", 4.79, "easeOutQuint")
animation("windowsIn", 4.1, "easeOutQuint", "popin 87%")
animation("windowsOut", 1.49, "linear", "popin 87%")

animation("fadeIn", 1.73, "almostLinear")
animation("fadeOut", 1.46, "almostLinear")
animation("fade", 3.03, "quick")

animation("layers", 3.81, "easeOutQuint")
animation("layersIn", 4, "easeOutQuint", "fade")
animation("layersOut", 1.5, "linear", "fade")
animation("fadeLayersIn", 1.79, "almostLinear")
animation("fadeLayersOut", 1.39, "almostLinear")

animation("workspaces", 1.94, "almostLinear", "fade")
animation("workspacesIn", 1.21, "almostLinear", "fade")
animation("workspacesOut", 1.94, "almostLinear", "fade")

-- SUPER keybinds; additional arguments pass through to hl.bind.
local dsp = hl.dsp

local function bind(key, action, ...)
  hl.bind(mod .. " + " .. key, action, ...)
end

-- Main keybinds
bind("Return", dsp.exec_cmd(terminal))
bind("I", dsp.exec_cmd(browser))
bind("SHIFT + Q", dsp.window.close {})
bind("M", dsp.exit()) -- If using UWSM, prefer 'uwsm stop'.
bind("R", dsp.layout("swapnext"))
bind("SHIFT + R", dsp.layout("swapprev"))
bind("F", dsp.window.fullscreen { action = "toggle" })
bind("Space", dsp.window.float { action = "toggle" })
bind("P", dsp.exec_cmd(menu))
bind("SHIFT + C", dsp.exec_cmd("hyprshot -m region"))

-- Delay the display power toggle by one second.
bind("Up", function()
  hl.timer(function()
    hl.dispatch(dsp.dpms { action = "toggle" })
  end, { timeout = 1000, type = "oneshot" })
end)

-- Pass the recording shortcut through to OBS.
bind("SHIFT + V", dsp.pass { window = "class:^(com\\.obsproject\\.Studio)$" })

-- Focus/navigation in the Master layout
bind("H", dsp.focus { direction = "l" })
bind("L", dsp.focus { direction = "r" })
bind("K", dsp.layout("cycleprev"))
bind("J", dsp.layout("cyclenext"))

-- Workspaces 1-10. Keys 1-9 map to workspace 1-9; key 0 maps to workspace 10.
for workspace = 1, 10 do
  local key = tostring(workspace % 10)
  local number = tostring(workspace)
  bind(key, dsp.focus { workspace = number })
  bind("SHIFT + " .. key, dsp.window.move { workspace = number, follow = true })
end

-- Special workspace (scratchpad)
bind("S", dsp.workspace.toggle_special("scratchpad"))
bind("SHIFT + S", dsp.window.move { workspace = "special:scratchpad", follow = true })

-- Workspace scrolling
bind("mouse_down", dsp.focus { workspace = "e+1" })
bind("mouse_up", dsp.focus { workspace = "e-1" })

-- Mouse window move/resize
bind("mouse:272", dsp.window.drag(), { mouse = true })
bind("mouse:273", dsp.window.resize(), { mouse = true })

-- Audio keys (allow on lock screen; hold to repeat volume changes)
hl.bind(
  "XF86AudioRaiseVolume",
  dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext", dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", dsp.exec_cmd("playerctl previous"), { locked = true })

-- Keep selected applications fully opaque.
local opaque_apps = {
  "(steam)(.*)",
  "(chromium)(.*)",
  "(vlc)(.*)",
  "(spotify)(.*)",
  "(teams)(.*)",
  "(vesktop)(.*)",
}
for _, class_pattern in ipairs(opaque_apps) do
  hl.window_rule {
    match = { class = class_pattern },
    opacity = "1.0 override 1.0 override 1.0 override",
  }
end

-- Ignore application maximize requests.
hl.window_rule { match = { class = ".*" }, suppress_event = "maximize" }
