# ❄️ Winter on Eli's Dotfiles（AMD 核显 · 单屏 · Hyprland 0.55）

这是把 **[AmadeusWM 的 winter 主题配色](https://github.com/AmadeusWM/dotfiles-hyprland)**（蓝粉渐变 + 雪片氛围）套到 **[elifouts/Dotfiles](https://github.com/elifouts/Dotfiles)**（现代维护中的 waybar + pywal + Hyprland 0.55 底座）上的定制版本，已针对 **AMD 核显 + 单显示器** 调好硬件配置。

> **TL;DR**：在刚装好的 Arch 上，放好本目录 → 跑 `install.sh` 选 1 → 进 Hyprland → `Alt+B` 选 winter。所有窗口圆角 + 蓝粉渐变边框 + 模糊阴影，waybar/wofi/kitty/swaync 全套 winter 配色。

---

## 📋 这套配置包含什么

| 来源 | 内容 |
|---|---|
| **Eli 底座** | Hyprland + waybar + wofi + swaync + swww + hyprlock/hypridle + pypr + kitty + nvim + starship + cava …（完整现代 Hyprland 工作流） |
| **winter 配色（新增）** | 一个 waybar winter 主题（写死蓝粉色，不依赖 pywal）、hyprland winter 装饰（圆角 16 + 蓝粉 45° 渐变边框 + 模糊 + 阴影）、winter 16 色 pywal 配色方案、2 张雪山壁纸 |
| **硬件适配** | AMD 图形栈（`vulkan-radeon`/`mesa`/`libva-mesa-driver`）已加进安装脚本；显示器改成单屏自动检测；移除 NVIDIA 专用变量 |

**配色**：深背景 `#0B0A10` · 主蓝 `#A8C5E6` · 主粉 `#f1a7e2` · 浅蓝 `#d3e8ff` · 青 `#93f0e2` · 白 `#eae9f0`

---

## ✅ 前提条件

部署前请确认：

- [x] **Arch Linux** 已装好（base 系统 + 能上网）
- [x] **国外网络环境**（AUR/yay 下载顺畅）
- [x] **Hyprland 已能启动**（`sudo pacman -S hyprland`；本安装脚本**不含** hyprland 本体）
- [x] 用**普通用户**操作（脚本装到 `~/.config`，**不要用 root**）
- [x] 硬件：**AMD 核显 + 单屏**（已预设；其他硬件见下方「硬件适配」）

---

## 🚀 完整部署步骤

### 步骤 0：基础包 + 启用 multilib（玩游戏才需要）

```bash
sudo pacman -S --needed git base-devel networkmanager
```

如果玩游戏 / 用 Steam，编辑 `/etc/pacman.conf`，取消 `[multilib]` 段及下一行 `Include` 的注释，然后：

```bash
sudo pacman -Sy
```

### 步骤 1：安装 yay（AUR 助手，安装脚本依赖它）

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### 步骤 2：放置 dotfiles 到约定位置

安装脚本硬编码从 `~/Dotfiles` 读取，所以**必须**把本目录放到那里：

```bash
# 假设你已把本目录下载/复制到某处（例如 ~/Downloads/Dotfiles-main）
mv ~/Downloads/Dotfiles-main ~/Dotfiles
```

### 步骤 3：运行安装器

```bash
cd ~/Dotfiles/InstallScripts
chmod +x *.sh
./install.sh
```

选 **`1`（Full install）**。脚本会自动完成：

1. 备份你现有的 `~/.config`、`~/.icons`、`~/wallpapers`（带时间戳）
2. 用 `yay` 装全部组件 + **AMD 图形栈**（`vulkan-radeon mesa libva-mesa-driver`）
3. 部署 winter 化的配置到 `~/.config`
4. 应用 winter 配色（`wal --theme winter`）→ wofi/kitty/swaync/hyprland 全部变 winter 色

> 💡 全自动模式（选 A）会装很多包（含 libreoffice/discord/vscode 等），耗时较长。想精简可选手动模式（选 M）逐个挑包。
> ⚠️ 脚本里有一步会用 `reflector` 把 pacman 镜像改成美国最快节点——如果你有自己的镜像偏好，手动模式里可以跳过「Update mirrorlist」。

### 步骤 4：进入 Hyprland

**方式 A（TTY 直接启动，最简单）：** 注销后在 TTY 登录界面输入用户名密码，然后执行
```bash
Hyprland
```

**方式 B（显示管理器）：** 装一个登录管理器
```bash
sudo pacman -S sddm
sudo systemctl enable --now sddm
```
注销后在登录界面右下角选 Hyprland 会话。

### 步骤 5：切换到 winter 主题

进入 Hyprland 桌面后，按 **`Alt + B`**，wofi 弹出主题选择菜单 → 选 **winter**（带雪山截图的那项）。waybar 立即变成深背景 + 蓝粉 accent。

> 窗口装饰（圆角 16 + 蓝粉渐变边框 + 模糊 + 阴影）是全局的，`hyprctl reload` 后所有窗口自动生效，无需手动切。

### 步骤 6：验证

- ✅ 窗口有圆角 + 蓝粉渐变边框 + 毛玻璃模糊 + 阴影
- ✅ 顶部 waybar 深色背景、蓝色 accent
- ✅ `Mod+R` 打开 wofi，配色也是 winter
- ✅ 终端 kitty 是 winter 配色

---

## ⌨️ 常用键位

| 键位 | 功能 |
|---|---|
| `Mod+Q` | 打开终端（kitty） |
| `Mod+R` | 应用启动器（wofi） |
| `Mod+B` | 关闭窗口 |
| `Mod+F` | 全屏 |
| `Mod+V` | 浮动切换 |
| `Mod+E` | 文件管理器（thunar） |
| `Mod+Space` | 终端 scratchpad |
| `Mod+M` | 退出 Hyprland |
| `Mod+1~0` | 切换工作区 1~10 |
| `Alt+B` | **waybar 主题选择**（选 winter） |
| `Alt+W` | 壁纸选择 |
| `Alt+Tab` | 电源菜单（wlogout） |

> `Mod` = Super（Win）键。完整键位见 `~/.config/hypr/hyprland.conf`。

---

## 🔧 硬件适配

本版本**已为 AMD 核显 + 单屏预设**。如果你的情况不同，改 `~/.config/hypr/hyprland.conf`：

### 显示器（单屏已设自动检测）
```ini
monitor=,preferred,auto,1          # 当前：自动检测
```
若分辨率/缩放不对，改成显式（用 `hyprctl monitors` 查接口名）：
```ini
monitor=eDP-1,1920x1080@60,0x0,1     # 1080p 笔记本
monitor=eDP-1,2560x1600,0x0,1.5      # 2K HiDPI 缩放 1.5
```
多屏：再加一行 `monitor=DP-1,...`。

### GPU 驱动
- **AMD 核显（当前）**：`vulkan-radeon` + `mesa` 已在安装脚本里，无需额外操作。
- **NVIDIA**：装 `nvidia` `nvidia-utils` 等，并在 hyprland.conf 顶部加回 `env = LIBVA_DRIVER_NAME,nvidia` 和 `env = __GLX_VENDOR_LIBRARY_NAME,nvidia`（参考 Hyprland wiki 的 NVIDIA 设置）。

---

## ⚠️ 已知限制

1. **XWayland 应用透明度**：winter 沿用 `active_opacity=0.78`（毛玻璃）。Wayland 原生应用会透明，但 **XWayland 应用（Windows 移植软件、微信、QQ、多数 Electron 应用）大多不支持透明**，会偏实色——这是 X11/XWayland 协议限制，任何 Hyprland 主题都一样。如需完全一致，把 `active_opacity` 改成 `1.0`。
2. **个别应用自带标题栏（CSD）**：少数 XWayland 应用自带边框/标题栏，需要针对具体应用加 `windowrulev2` 去除（装完遇到再处理）。
3. **首次启动**：`hyprland.conf` 第 1 行 `source ~/.cache/wal/colors-hyprland`，安装脚本已生成该文件；若你手动删过 `~/.cache/wal`，跑一次 `wal --theme winter` 重新生成。

---

## 🆘 故障排查

| 现象 | 解决 |
|---|---|
| 进 Hyprland 黑屏 / 无显示 | `hyprctl monitors` 看接口名，改 `hyprland.conf` 的 `monitor=` |
| Hyprland 报 Vulkan 错 | 确认装了 `vulkan-radeon`：`pacman -Q vulkan-radeon` |
| waybar 没颜色 / 全黑 | 按 `Alt+B` 选 winter；或检查 `~/.cache/wal/colors-waybar.css` 是否存在（不存在跑 `wal --theme winter`） |
| `wal --theme winter` 报错 | 确认 `~/.config/wal/colorschemes/dark/winter.json` 存在 |
| 应用模糊/发虚（Electron/Spotify/Discord） | 见 Eli 原文档：给 `.desktop` 加 `--enable-features=UseOzonePlatform --ozone-platform=wayland` |
| `~/.cache/wal/` 里文件找不到 | pywal 生成的，文件里有 `/home/eli/` 旧路径就替换成你的用户名 |

---

## ↩️ 回滚

安装脚本已自动把你旧的 `~/.config` 备份到 `~/.config_backup_<时间戳>`。要还原：

```bash
rm -rf ~/.config
mv ~/.config_backup_<时间戳> ~/.config
```

---

## 🙏 致谢

- **[Eli Fouts (elifouts)](https://github.com/elifouts/Dotfiles)** — 底座（waybar + pywal + 完整 Hyprland 工作流），本仓库的所有基础设施与组件文档均来自他。原始组件说明见 [`readme.md`](./readme.md)。
- **[AmadeusWM](https://github.com/AmadeusWM/dotfiles-hyprland)** — winter 主题配色（蓝粉渐变 + 雪片 + Apatheia 美学）的原创者。

本仓库仅为个人定制的二创组合，请同样遵守上游两位作者的许可证。
