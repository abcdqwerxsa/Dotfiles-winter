#!/bin/bash
# GUI 系统设置启动器 —— wofi 菜单。
# 绑定：Super+I；waybar 齿轮左键也调它，右键直接开 gnome-control-center。
set -euo pipefail

# 标签 | 命令
items=(
  "System Settings|XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
  "Sound|pavucontrol"
  "Network|nm-connection-editor"
  "Bluetooth|blueman-manager"
  "Displays|wdisplays"
  "Appearance — GTK|nwg-look"
  "Appearance — Qt|qt6ct"
  "Wallpaper|$HOME/.config/hypr/wallpaper.sh"
  "Waybar theme|$HOME/.config/waybar/scripts/select.sh"
  "Notifications|swaync-client -t -sw"
  "Power menu|wlogout"
)

choice=$(printf '%s\n' "${items[@]}" | cut -d'|' -f1 | wofi --show dmenu --prompt "Settings:" -i)
[ -z "${choice:-}" ] && exit 0

cmd=""
for it in "${items[@]}"; do
  if [ "${it%%|*}" = "$choice" ]; then cmd="${it#*|}"; break; fi
done
[ -z "$cmd" ] && exit 0
exec sh -c "$cmd"
