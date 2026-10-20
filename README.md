# Keyboard Island · 键盘小岛 - LazyCat App

[Keyboard Island](https://github.com/shaom/keyboard-island)（儿童打字启蒙冒险游戏：16 个世界 96 章节、288 关卡、房间装饰收集、可选本地面部追踪）的懒猫微服（LazyCat）打包。

## 模式

- **静态应用**：内容直接来自上游 GitHub Release 资产（`keyboard-island-v{ver}.zip`，带 sha256 校验），以 `file://` 路由提供，无服务端。
- **跟随上游 tag**：每日检查上游最新 release，自动更新版本号并重新发布。
- **喵喵商店发布**：仅私有商店（MiaoMiao private store），不发布官方商店。

## 说明

- 游戏界面/故事/语音脚本为简体中文；进度保存在浏览器本地
- 语音 MP3 因授权问题不含在开源版内（游戏本地合成音乐与音效已包含）；可在设置中启用家长选项
- 可选摄像头面部追踪：默认关闭，需用户显式开启（纯本地推理，不上传）
- 建议配合物理 QWERTY 键盘使用

## 所需 Secrets

| Secret | 说明 |
| --- | --- |
| `APPSTORE_URL` / `APPSTORE_TOKEN` | 喵喵商店 API 地址与发布令牌 |
| `APP_ID` | 可选 |
| `PRIVATE_STORE_GROUP_CODES` | 可选，私有分组码 |

## 许可

MIT（上游）
