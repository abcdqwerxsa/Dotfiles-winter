#!/bin/bash
# =============================================================================
#  Dotfiles Installer — by EF
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}[•]${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${RESET} $*"; }
error()   { echo -e "${RED}${BOLD}[✗]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
  ____        _    __ _ _
 |  _ \  ___ | |_ / _(_) | ___  ___
 | | | |/ _ \| __| |_| | |/ _ \/ __|
 | |_| | (_) | |_|  _| | |  __/\__ \
 |____/ \___/ \__|_| |_|_|\___||___/

EOF
echo -e "${RESET}"

# ── Sanity checks ─────────────────────────────────────────────────────────────
DOTFILES_DIR="$HOME/Dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR. Aborting."
    exit 1
fi

if ! command -v yay &>/dev/null; then
    error "'yay' AUR helper not found. Please install it first."
    exit 1
fi

# ── Shared helpers ────────────────────────────────────────────────────────────

backup_config() {
    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    local items=(
        "$HOME/.config:$HOME/.config_backup_${timestamp}"
        "$HOME/.icons:$HOME/.icons_backup_${timestamp}"
        "$HOME/wallpapers:$HOME/wallpapers_backup_${timestamp}"
    )

    local backed_up=false

    for item in "${items[@]}"; do
        local source_path="${item%%:*}"
        local backup_path="${item#*:}"

        if [ -e "$source_path" ]; then
            info "Backing up $(basename "$source_path") → $backup_path"
            mkdir -p "$backup_path"
            cp -a "$source_path/." "$backup_path/"
            success "Backed up $(basename "$source_path")"
            backed_up=true
        else
            warn "$(basename "$source_path") not found — skipping backup."
        fi
    done

    if $backed_up; then
        success "Backups created for .config, .icons, and wallpapers"
    else
        warn "No dotfiles were backed up."
    fi
}

backup_bashrc() {
    local backup_dir="${HOME}/.bashrc_backup_$(date +%Y%m%d_%H%M%S)"

    if [ ! -f "$HOME/.bashrc" ]; then
        warn "~/.bashrc not found — skipping backup."
        return
    fi

    info "Backing up .bashrc → $backup_dir"
    mkdir -p "$backup_dir"
    cp -a "$HOME/.bashrc" "$backup_dir/.bashrc"
    success "Backup created at $backup_dir/.bashrc"
}

apply_dotfiles() {
    section "Applying Dotfiles"
    info "Copying wallpapers..."
    cp -a "$DOTFILES_DIR/wallpapers" "$HOME/"

    info "Copying .icons..."
    cp -a "$DOTFILES_DIR/.icons" "$HOME/"

    info "Copying .config files..."
    cp -a "$DOTFILES_DIR/.config/." "$HOME/.config/"

    info "Copying .bashrc..."
    cp -a "$DOTFILES_DIR/.bashrc" "$HOME/"

    fix_wofi_paths
    success "Dotfiles applied."
}

fix_wofi_paths() {
    local config_dir="$HOME/.config/wofi"

    if [ ! -d "$config_dir" ]; then
        warn "Wofi config directory not found at $config_dir — skipping path fix."
        return
    fi

    info "Fixing wofi CSS paths for user: $USER"
    find "$config_dir" -maxdepth 1 -type f -name "*.css" -print0 \
    | while IFS= read -r -d '' file; do
        sed -i -E \
            "s|/home/[^/]+/\.cache/wal/colors-waybar\.css|$HOME/.cache/wal/colors-waybar.css|g" \
            "$file"
        success "Updated: $file"
    done
}

setup_wallpaper() {
    section "Setting Wallpaper (pywal)"
    local wallpaper="$DOTFILES_DIR/wallpapers/pywallpaper.jpg"
    if [ -f "$wallpaper" ]; then
        wal -i "$wallpaper" -n
        success "Wallpaper set."
    else
        warn "Wallpaper not found at $wallpaper — skipping."
    fi
}

apply_winter_theme() {
    section "Applying Winter Color Scheme"
    if ! command -v wal >/dev/null 2>&1; then
        warn "'wal' not found, skipping winter theme."
        return
    fi
    # winter.json was just deployed to ~/.config/wal/colorschemes/dark/ by apply_dotfiles.
    # This regenerates ~/.cache/wal/colors-* so wofi/kitty/swaync/swayosd/hyprland all use winter colors.
    if wal --theme winter -n; then
        success "Winter color scheme applied — all components winter-colored."
    else
        warn "winter theme apply failed — run 'wal --theme winter' manually after install."
    fi
}

setup_sddm() {
    section "SDDM Login Manager (winter theme)"
    local theme_src="$DOTFILES_DIR/.config/sddm/themes/winter"
    local theme_dst="/usr/share/sddm/themes/winter"
    if [[ ! -d "$theme_src" ]]; then
        warn "winter sddm theme not found at $theme_src — skipping."
        return
    fi
    # SDDM reads themes from /usr/share/sddm/themes (system-wide), so copy there.
    sudo mkdir -p /usr/share/sddm/themes /etc/sddm.conf.d
    sudo cp -r "$theme_src" "$theme_dst"
    # 壁纸软链：登录界面用桌面同一张壁纸（pywallpaper.jpg 随壁纸变化自动更新）
    sudo ln -sf "$HOME/wallpapers/pywallpaper.jpg" "$theme_dst/Background.jpg"
    # 让 SDDM greeter（sddm 用户）能穿过 $HOME 读到壁纸文件
    chmod o+x "$HOME"
    printf '[Theme]\nCurrent=winter\n' | sudo tee /etc/sddm.conf.d/winter.conf > /dev/null
    sudo systemctl enable sddm
    success "SDDM enabled with winter theme (takes effect after reboot)."
}

setup_dynamic_cursors() {
    section "Dynamic Cursors"
    if hyprpm add https://github.com/virtcode/hypr-dynamic-cursors && \
       hyprpm enable dynamic-cursors; then
        success "Dynamic cursors enabled."
    else
        warn "Dynamic cursors setup failed — you may need to run this manually."
    fi
}

setup_mirrors() {
    section "Updating Pacman Mirrorlist"
    yay -S --needed reflector rsync
    sudo reflector --country 'US' --latest 10 --sort rate \
        --save /etc/pacman.d/mirrorlist
    success "Mirrorlist updated."
}

setup_bluetooth() {
    section "Bluetooth"
    yay -S --needed blueman bluez
    sudo systemctl enable --now bluetooth
    success "Bluetooth enabled."
}

setup_pipewire() {
    section "Pipewire & Audio"
    yay -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack \
        pavucontrol pulsemixer gnome-network-displays gst-plugins-bad
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
    success "Pipewire configured."
}

finish() {
    success "Installation complete! 🎉"
    notify-send \
        "Dotfiles Installed" \
        "Open Terminal with MOD+Q\nHello $USER — Thanks for using my Dotfiles!\n-EF" \
        2>/dev/null || true
}

# ── Core packages ─────────────────────────────────────────────────────────────
CORE_PACKAGES=(
    python-pywal16 awww waybar swaync starship myfetch neovim python-pywalfox
    vulkan-radeon mesa libva-mesa-driver   # AMD 图形栈（Hyprland 需 Vulkan；原配置面向 nvidia）
    sddm hyprpolkitagent hypridle hyprpicker hyprshot hyprlock hyprmon pacman-contrib pyprland wlogout fd
    cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme
    materia-gtk-theme illogical-impulse-bibata-modern-classic-bin
    thunar gvfs tumbler eza bottom htop libreoffice-fresh spotify-launcher ncspot imv mpv
    discord visual-studio-code-bin yazi lazygit swayosd-git
    # 中文输入法 fcitx5
    fcitx5 fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-pinyin-zhwiki
    # 中文字体 + emoji
    noto-fonts-cjk noto-fonts-emoji
    # 系统设置 GUI
    gnome-control-center wdisplays qt5ct qt6ct blueman
)

OPTIONAL_PACKAGES=(bluez pipewire pipewire-pulse pipewire-alsa
    pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad)

# ── Installation modes ────────────────────────────────────────────────────────

auto_install() {
    section "Automatic Installation"

    setup_mirrors

    info "Installing all packages..."
    yay -S --needed "${CORE_PACKAGES[@]}"
    success "Core packages installed."

    sudo systemctl enable --now avahi-daemon

    setup_bluetooth
    setup_pipewire
    setup_wallpaper
    setup_dynamic_cursors
    apply_dotfiles
    # 刷新字体缓存（中文字体/emoji 字体需要）
    fc-cache -f
    apply_winter_theme
    setup_sddm
    finish
}

manual_install() {
    section "Manual Installation"

    read -rp "Update mirrorlist for best US servers? (Y/n): " m
    [[ "${m:-y}" =~ ^[Yy]$ ]] && setup_mirrors

    section "Package Selection"
    for pkg in "${CORE_PACKAGES[@]}"; do
        read -rp "  Install ${BOLD}${pkg}${RESET}? (Y/n): " choice
        [[ "${choice:-y}" =~ ^[Yy]$ ]] && yay -S --needed "$pkg" && clear
    done

    setup_wallpaper

    read -rp "Install Bluetooth support? (Y/n): " b
    [[ "${b:-y}" =~ ^[Yy]$ ]] && setup_bluetooth

    read -rp "Configure Pipewire & Network Displays? (Y/n): " p
    [[ "${p:-y}" =~ ^[Yy]$ ]] && setup_pipewire

    read -rp "Enable Dynamic Cursors? (Y/n): " c
    [[ "${c:-y}" =~ ^[Yy]$ ]] && setup_dynamic_cursors

    apply_dotfiles
    # 刷新字体缓存（中文字体/emoji 字体需要）
    fc-cache -f
    apply_winter_theme
    setup_sddm
    finish
}

# ── Entry point ───────────────────────────────────────────────────────────────

section "Welcome"

read -rp "Installation mode — (A)utomatic or (M)anual? [A]: " install_choice
install_choice="${install_choice:-a}"

read -rp "Backup your current dotfiles before installing? (Y/n): " backup_choice
[[ "${backup_choice:-y}" =~ ^[Yy]$ ]] && backup_config && backup_bashrc

case "${install_choice,,}" in
    a) auto_install  ;;
    m) manual_install ;;
    *) error "Unknown option '$install_choice'. Exiting."; exit 1 ;;
esac
