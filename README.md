# ❄️ Dotfiles-winter

winter 主题配色（蓝粉渐变 + 雪片氛围）的两套实现，均适配 **Hyprland 0.55**。

## 两个部分

### 1️⃣ `Dotfiles-main/` — 完整可部署版（⭐ 推荐）

把 winter 配色套到 **[elifouts/Dotfiles](https://github.com/elifouts/Dotfiles)**（现代维护中的 waybar + pywal + Hyprland 0.55 底座），已为 **AMD 核显 + 单屏** 定制好硬件配置，开箱即用。

👉 **部署文档看这里：[`Dotfiles-main/README.md`](./Dotfiles-main/README.md)**

包含：winter waybar 主题、hyprland winter 装饰（圆角 16 + 蓝粉 45° 渐变边框 + 模糊 + 阴影）、winter 16 色 pywal 配色方案、2 张雪山壁纸、一键安装脚本、完整部署/故障排查文档。

### 2️⃣ 根目录 — winter eww 主题（0.55 迁移版）

**[AmadeusWM winter 主题](https://github.com/AmadeusWM/dotfiles-hyprland)** 的原始 eww 实现（雪片 launcher、中文数字工作区、Apatheia 日语名言侧栏、neofetch 侧栏），已从 2022 版迁移到 Hyprland 0.55：

- `theme.conf`、`eww/`、`scripts/`、`dots/`、`wallpapers/`、`assets/`

迁移内容：socket 路径（`/tmp/hypr/` → `$XDG_RUNTIME_DIR/hypr/`）、IPC 事件解析（字符串偏移 → `case`+`${line#*>>}`）、blur/shadow 旧语法 → 子块、`hyprctl` 文本解析 → `-j|jq`、`exec=` → `exec-once=`。

> ⚠️ eww 版需要 AmadeusWM 的 `dotfiles-hyprland` 主仓库作底座（提供 `exec_wofi`、`load_envs` 等）。如果你只想要「开箱即用的 winter 配色桌面」，直接用上面的 `Dotfiles-main/`。

---

## 🎨 配色

| | 值 |
|---|---|
| 背景 | `#0B0A10` |
| 主蓝 | `#A8C5E6` |
| 主粉 | `#f1a7e2` |
| 浅蓝 | `#d3e8ff` |
| 青 | `#93f0e2` |
| 白 | `#eae9f0` |

---

## 🙏 致谢

- **[Eli Fouts (elifouts)](https://github.com/elifouts/Dotfiles)** — waybar + pywal 底座与完整 Hyprland 工作流
- **[AmadeusWM](https://github.com/AmadeusWM/dotfiles-hyprland)** — winter 主题配色（蓝粉渐变 + 雪片 + Apatheia）的原创者

本仓库为个人定制的二创组合，许可证随各上游项目。
