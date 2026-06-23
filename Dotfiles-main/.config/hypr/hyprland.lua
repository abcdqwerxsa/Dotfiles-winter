-- ─────────────────────────────────────────────────────────
-- Winter Hyprland 配置（lua 格式）— 从 hyprland.conf 迁移
-- 配色：bg #0B0A10 · 蓝 #A8C5E6 · 粉 #f1a7e2 · 白 #eae9f0
-- ─────────────────────────────────────────────────────────

-- ========== MONITOR ==========
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- ========== PROGRAMS ==========
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi -n"

-- ========== AUTOSTART (exec-once) ==========
hl.on("hyprland.start", function()
    hl.exec_cmd("wal -R")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 12")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("pypr")
    hl.exec_cmd("swaync-client -df")
    hl.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 0")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sleep .5 && awww restore")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("fcitx5 -d --replace")
end)

-- ========== ENV ==========
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("XCURSOR_SIZE", "12")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("GTK_IM_MODULE", "fcitx")

-- ========== GENERAL ==========
hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 15,
        border_size = 4,
        col = {
            active_border   = { colors = {"rgba(A8C5E6ff)", "rgba(f1a7e2ff)"}, angle = 45 },
            inactive_border = "rgba(0B0A10ff)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },
})

-- ========== DECORATION ==========
hl.config({
    decoration = {
        rounding          = 16,
        active_opacity    = 0.78,
        inactive_opacity  = 0.7,
        fullscreen_opacity = 1.0,
        blur = {
            enabled         = true,
            size            = 8,
            passes          = 2,
            ignore_opacity  = true,
            xray            = true,
            popups          = true,
        },
        shadow = {
            enabled      = true,
            range        = 15,
            render_power = 2,
            color        = "rgba(0, 0, 0, 0.33)",
        },
    },
})

-- ========== ANIMATIONS ==========
hl.curve("fluid",  { type = "bezier", points = { {0.15, 0.85}, {0.25, 1} } })
hl.curve("snappy", { type = "bezier", points = { {0.3, 1}, {0.4, 1} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 3,   bezier = "fluid",  style = "popin 5%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "snappy" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4,   bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.7, bezier = "snappy", style = "slide" })

-- ========== DWINDLE ==========
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- ========== MISC ==========
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
        focus_on_activate       = false,
    },
})

-- ========== XWAYLAND ==========
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-- ========== INPUT ==========
hl.config({
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0.6,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- ========== DEVICE ==========
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = 0,
})

-- ========== KEYBINDINGS ==========
local mainMod = "SUPER"

-- 窗口
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/settings-menu.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- 焦点移动
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- 工作区
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- 特殊工作区
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Alt + 方向键 移动窗口
hl.bind("ALT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("ALT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + down",  hl.dsp.window.move({ direction = "down" }))

-- 截图
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Screenshots/"))
hl.bind("Print",        hl.dsp.exec_cmd("hyprshot -m window -o ~/Screenshots/"))
hl.bind("ALT + Print",  hl.dsp.exec_cmd("hyprshot -m active -m output -o ~/Screenshots/"))

-- 系统
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()'"))

-- Alt+Tab = 电源菜单（Eli 设定）
hl.bind("ALT + Tab", hl.dsp.exec_cmd("wlogout -b 2"))

-- 主题/壁纸/栏
hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/hypr/wallpaper.sh"))
hl.bind("ALT + A", hl.dsp.exec_cmd("~/.config/waybar/scripts/refresh.sh"))
hl.bind("ALT + B", hl.dsp.exec_cmd("~/.config/waybar/scripts/select.sh"))
hl.bind("ALT + R", hl.dsp.exec_cmd("~/.config/swaync/refresh.sh"))

-- Scratchpad（pypr）
hl.bind(mainMod .. " + Space",    hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + G",        hl.dsp.exec_cmd("pypr toggle music"))
hl.bind(mainMod .. " + T",        hl.dsp.exec_cmd("pypr toggle taskbar"))
hl.bind(mainMod .. " + Escape",   hl.dsp.exec_cmd("pypr toggle spotify"))

-- 媒体键（swayosd）
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +15"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -15"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })
hl.bind("Caps_Lock",            hl.dsp.exec_cmd("sleep 0.1 && swayosd-client --caps-lock"), { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness +10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness -10"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("swayosd-client --playerctl next"), { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("swayosd-client --playerctl previous"), { locked = true })

-- 鼠标
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ========== GESTURES ==========
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- ========== LAYER RULES ==========
hl.layer_rule({
    name         = "blur-waybar",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name         = "blur-swaync-control",
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.3,
})

hl.layer_rule({
    name         = "blur-swaync-notif",
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 0.3,
})

hl.layer_rule({
    name         = "no-anim-selection",
    match        = { namespace = "selection" },
    no_anim      = true,
})

hl.layer_rule({
    name         = "blur-swayosd",
    match        = { namespace = "swayosd" },
    blur         = true,
    ignore_alpha = 0.5,
})
