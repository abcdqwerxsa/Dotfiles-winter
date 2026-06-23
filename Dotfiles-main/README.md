# ❄️ Winter on Eli's Dotfiles（AMD 核显 · 单屏 · Hyprland 0.55）

这是把 **[AmadeusWM 的 winter 主题配色](https://github.com/AmadeusWM/dotfiles-hyprland)**（蓝粉渐变 + 雪片氛围）套到 **[elifouts/Dotfiles](https://github.com/elifouts/Dotfiles)**（现代维护中的 waybar + pywal + Hyprland 0.55 底座）上的定制版本，已针对 **AMD 核显 + 单显示器** 调好硬件配置。

> **TL;DR**：在刚装好的 Arch 上，放好本目录 → 跑 `install.sh` 选 1 → 进 Hyprland → `Alt+B` 选 winter。所有窗口圆角 + 蓝粉渐变边框 + 模糊阴影，waybar/wofi/kitty/swaync 全套 winter 配色。

---

## 📋 这套配置包含什么

| 来源 | 内容 |
|---|---|
| **Eli 底座** | Hyprland + waybar + wofi + swaync + awww + hyprlock/hypridle + pypr + kitty + nvim + starship + cava …（完整现代 Hyprland 工作流） |
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

### 步骤 4：重启 → winter 登录界面

安装脚本已自动装好 **SDDM** 登录管理器并启用 **winter 登录主题**（雪山背景 + 蓝色大时钟 + 蓝粉登录卡片 + 电源按钮）。直接重启：

```bash
sudo reboot
```

开机即图形登录界面——输用户名、输密码（回车），自动进入 Hyprland（会话默认已选 Hyprland）。

> 想退回 TTY 直接启动（不要图形登录界面）：`sudo systemctl disable sddm`，重启后在 TTY 敲 `Hyprland`。
> 如果开机没出 winter 登录界面而是黑屏/默认 sddm：`sudo sddm-greeter --test-mode --theme /usr/share/sddm/themes/winter` 预览排查。

### 步骤 5：切换到 winter 主题

进入 Hyprland 桌面后，按 **`Alt + B`**，wofi 弹出主题选择菜单 → 选 **winter**（带雪山截图的那项）。waybar 立即变成深背景 + 蓝粉 accent。

> 窗口装饰（圆角 16 + 蓝粉渐变边框 + 模糊 + 阴影）是全局的，`hyprctl reload` 后所有窗口自动生效，无需手动切。

### 步骤 6：验证

- ✅ 窗口有圆角 + 蓝粉渐变边框 + 毛玻璃模糊 + 阴影
- ✅ 顶部 waybar 深色背景、蓝色 accent
- ✅ `Mod+R` 打开 wofi，配色也是 winter
- ✅ 终端 kitty 是 winter 配色

---

## 🧩 桌面组件（开机自启）

| 组件 | 作用 |
|---|---|
| **waybar** | 顶部状态栏：时钟、工作区圆点、通知、蓝牙、网络、电池、可展开的 CPU/内存/温度 |
| **wofi** | 应用启动器（`Mod+R`）、主题/壁纸选择菜单 |
| **swaync** | 通知中心（弹通知 + 控制面板） |
| **swayosd** | 调音量/亮度/大写时屏幕弹 OSD |
| **hyprlock** | 锁屏（winter 壁纸背景） |
| **hypridle** | 空闲自动锁屏/睡眠 |
| **awww** | 壁纸引擎（带过渡动画） |
| **pypr** | scratchpad——下拉式浮窗（终端/音乐/taskbar/spotify） |
| **wlogout** | 电源菜单（关机/重启/睡眠/注销） |

## ⌨️ 快捷键速查

> `Mod` = **Super（Windows）键**。完整列表见 `~/.config/hypr/hyprland.conf`。

**窗口**

| 键 | 功能 |
|---|---|
| `Mod+Q` | 终端（kitty） |
| `Mod+E` | 文件管理器（thunar） |
| `Mod+B` | 关闭窗口 |
| `Mod+V` | 浮动/平铺切换 |
| `Mod+F` | 全屏 |
| `Mod+P` | 伪平铺 |
| `Mod+↑↓←→` | 切焦点 |
| `Alt+↑↓←→` | 移动窗口到方向 |
| `Mod+左键拖` / `Mod+右键拖` | 移动 / 调整窗口 |

**工作区**

| 键 | 功能 |
|---|---|
| `Mod+1~9` / `Mod+0` | 切到工作区 1~9 / 10 |
| `Mod+Shift+1~0` | 把窗口移到该工作区 |
| `Mod+S` | 特殊工作区（magic，隐藏区） |
| `Mod+Shift+S` | 把窗口移到特殊工作区 |
| 三指横滑触控板 | 切工作区 |

**scratchpad 下拉浮窗**（再按一次收起）

| 键 | 功能 |
|---|---|
| `Mod+Space` | 下拉终端 |
| `Mod+G` | 音乐播放器 |
| `Mod+T` | taskbar |
| `Mod+Esc` | spotify |

**启动 / 系统**

| 键 | 功能 |
|---|---|
| `Mod+R` | wofi 应用启动器 |
| `Mod+L` | 锁屏 |
| `Mod+M` | 退出 Hyprland |
| `Alt+Tab` | ⚠️ **电源菜单**（不是切窗口） |

**主题 / 壁纸 / 栏**

| 键 | 功能 |
|---|---|
| `Alt+B` | 切 waybar 主题（选 **winter**） |
| `Alt+A` | 重启/切换 waybar |
| `Alt+W` | 选壁纸（同时更新配色） |
| `Alt+R` | 刷新 swaync 样式 |

**截图**（存 `~/Screenshots/`）

| 键 | 功能 |
|---|---|
| `Print` | 截窗口 |
| `Ctrl+Print` | 框选区域 |
| `Alt+Print` | 全屏 |

**媒体键**（键盘 Fn 区，无需 Mod）：音量 ± / 静音 / 麦克风 · 亮度 ± · 播放暂停/上下首 · `Caps Lock`，均带 OSD 提示。

## 📦 主要应用

终端 **kitty** + **starship**；编辑 **neovim** / VS Code / lazygit；文件 **thunar** / **yazi**；图片 **imv**；视频 **mpv**；音频可视化 **cava**；办公 libreoffice；通讯 discord；音乐 spotify-launcher / ncspot。

## ⚠️ 两个反直觉点

1. **`Alt+Tab` 是电源菜单**（不是切窗口）——Eli 的设定。想要 Alt+Tab 切窗口可在 `hyprland.conf` 加 `bind = Alt, Tab, cyclenext`。
2. **没有「最小化」**——平铺式桌面，不用就 `Mod+B` 关掉，或 `Mod+Shift+数字` 丢到别的工作区。

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

## 🆕 新增功能（2026-06 调整）

### ⚠️ Hyprland 配置格式：`.lua` 优先（重要！）

Hyprland 0.55.4 **优先读 `~/.config/hypr/hyprland.lua`**（lua 格式），不是 `.conf`。如果 `.lua` 存在（即使空文件），`.conf` 会被忽略。本配置已迁移到 `.lua` 格式（`.conf` 保留作回退备份）。

> 🚨 **如果桌面变成"裸"的（无快捷键、无 waybar、无主题）**：检查 `~/.config/hypr/hyprland.lua` 是否被清空（0 字节）。恢复：`cp hyprland.lua.bak hyprland.lua` + 重启 Hyprland。

### 🀄 中文输入法（fcitx5 + 紫光双拼）

- **Ctrl+Space** 切换中/英文
- 默认提供三个输入法：英文 / **紫光双拼** / 全拼
- Ctrl+Shift 循环切换；或点 waybar 托盘 fcitx 图标选择
- 切双拼方案：`fcitx5-configtool` → Pinyin → 双拼方案 → 紫光

### ⚙️ 系统设置入口（GUI）

- **Super+I** → wofi 设置菜单（声音/网络/蓝牙/显示器/外观/壁纸/栏主题/通知/电源）
- **waybar 齿轮左键** → 同上菜单；**右键** → gnome-control-center（完整设置窗口）
- gnome-control-center 需 `XDG_CURRENT_DESKTOP=GNOME` 才能在 Hyprland 下打开（已在 settings-menu.sh 里处理）

### 😀 emoji 与中文字体

- `noto-fonts-cjk`（中文）+ `noto-fonts-emoji`（彩色表情）已加入安装脚本
- kitty 配了 `symbol_map` 让 emoji 正常显示（不再是方格）
- SSH 终端也有 winter 配色（`.bashrc` 里 `cat ~/.cache/wal/sequences`）

### 🎨 终端 (kitty)

- 字体大小 14px（默认 11）
- 字体：Hurmit Nerd Font

### 📝 Neovim

- 默认主题：**rose-pine**（暗蓝粉，跟 winter 搭），带透明背景
- `:ThemePywal` 切回精确 winter 色调
- 其它可用：`:ThemeFileCatppuccin` / `:ThemeFileTokyo` / `:ThemeFileKanagawa` 等

### 🌐 默认浏览器

- Google Chrome（mimeapps.list 已设 http/https/html → chrome）

### 🔒 锁屏（hyprlock）

- **Super+L** → 锁屏
- 锁屏壁纸 = 当前桌面壁纸（pywallpaper.jpg），模糊 + 暗化
- 空闲 ~16 分钟自动锁（hypridle）；原 hyprdvd 弹跳屏保已禁用（会导致窗口乱跳）

### 🖥️ 登录界面（SDDM winter）

- 使用桌面同一张壁纸（Background.jpg → pywallpaper.jpg 软链）
- 时钟/日期/密码框样式与 hyprlock 对齐
- 安装脚本自动 `chmod o+x $HOME` 让 SDDM 能读到壁纸

### ⚠️ 已知限制（补充）

1. **`hyprctl reload` 在 0.55.4 可能不生效**——改配置后可能需要重启 Hyprland（注销重登），不能只靠 reload
2. **waybar 工作区点击**跟 Hyprland 0.55.4 新 IPC 不完全兼容——键盘 Super+1~9 正常，鼠标点击可能无反应（等 waybar 更新适配）
3. **鼠标共享（Deskflow/Barrier）在 Wayland 上不走通**——Hyprland 缺 `InputCapture` portal 接口；Arch 当 server/client 都不行。建议用硬件 USB 切换器
4. **waybar CSS 裸数字警告**——`margin:10` 之类没写 `px`，GTK 自动按 px 处理，非致命
5. **gnome-control-center 显示器/鼠标键盘面板**在 Hyprland 上不生效——用 wdisplays / hyprland.lua 调这些

---

## 🙏 致谢

- **[Eli Fouts (elifouts)](https://github.com/elifouts/Dotfiles)** — 底座（waybar + pywal + 完整 Hyprland 工作流），本仓库的所有基础设施与组件文档均来自他。原始组件说明见 [`readme.md`](./readme.md)。
- **[AmadeusWM](https://github.com/AmadeusWM/dotfiles-hyprland)** — winter 主题配色（蓝粉渐变 + 雪片 + Apatheia 美学）的原创者。

本仓库仅为个人定制的二创组合，请同样遵守上游两位作者的许可证。
